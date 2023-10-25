import json
import os
from datetime import datetime
from pathlib import Path

import requests
from source.core.database.dbutils import DatabaseUtils
import source.core.utils as utils
from source.tools.self_made.fileupload.fileupload import FileUpload

ROOTPATH = Path(__file__).parent.parent.parent
MODULES = ['ffuf', 'dirsearch', 'lfi', 'sqli',
           'xss', 'fileupload', 'idor', 'pathtraversal']


class WebVuln:
    def __init__(self) -> None:
        self.__debug = False
        self.__database = DatabaseUtils()

    def setDebug(self, debug: bool) -> None:
        self.__debug = debug

    def getDebug(self) -> bool:
        return self.__debug

    def sendFlask(self, data):
        """Send data to Flask.

        :param data: JSON object"""
        keys = json.loads(data).keys()
        if 'result' in keys and len(keys) == 1:
            try:
                if self.__debug:
                    utils.log(
                        f'/api/result: Sending data to Flask: {data}', "DEBUG")
                requests.post(url='http://localhost:5000//api/result', data=data, headers={
                              'Content-Type': 'application/json', 'Origin': 'backend'})
            except Exception as e:
                utils.log(f'Error: {e}', "ERROR")
                return e

    def recvFlask(self, route, method, jsonData) -> None:
        """Receive data from Flask based on the route.

        :param route: The route of the request
        :param method: `GET` or `POST`
        :param jsonData: JSON object
        """
        if self.__debug:
            print(f'{method} {route}: {jsonData.keys()}')
        if route == '/api/history':
            return self.getScanResult(method, jsonData)
        elif route == '/api/resources':
            return self.resourceHandler(method, jsonData)
        elif route == '/api/scan':
            return self.scanURL(jsonData['urls'])
        else:
            utils.log(f'Error: Invalid route {route}', "ERROR")
            return 'Failed'

    def scanURL(self, urls, modules):
        """Scan the URLs.

        :param urls: List of URLs
        :param modules: List of modules
        """

        commands = []
        jsonFiles = []
        dirURL = {}
        if isinstance(urls, list) is False:
            raise TypeError("URLs must be a list")
        elif isinstance(modules, list) is False:
            raise TypeError("Modules must be a list")
        if urls == [] or modules == []:
            raise ValueError("URLs and/or modules must not be empty")
        for url in urls:
            filename = f'scanresult_url{urls.index(url)}.json'
            jsonFiles.append(filename)
            if 'ffuf' in modules:
                commands.append(
                    f'{ROOTPATH}/source/tools/public/ffuf/ffuf.exe -u {url}/FUZZ -w {ROOTPATH}/source/tools/public/ffuf/fuzz-Bo0oM.txt -of json -o {filename} -p 0.2 -mc 200')
            elif 'dirsearch' in modules:
                commands.append(
                    f'python {ROOTPATH}/source/tools/public/dirsearch/dirsearch.py -u {url} -w {ROOTPATH}/source/tools/public/ffuf/fuzz-Bo0oM.txt -t 50 --format=json -x 404 -o {filename}')
            if commands != []:
                utils.multiprocess('result.txt', *commands)
                for jsonFile in jsonFiles:
                    with open(jsonFile, 'r') as f:
                        data = json.load(f)
                        for res in data["results"]:
                            if f'{url}' not in dirURL.keys():
                                dirURL[f'{url}'] = []
                            dirURL[f'{url}'].append(res['url'])
                    f.close()
                    os.remove(jsonFile)
            else:
                dirURL[f'{url}'] = [f'{url}']
        commands = []  # Reinitalize the commands
        for module in modules:
            if module == 'ffuf':
                pass
            elif module == 'dirsearch':
                pass
            elif module == 'lfi':
                pass
            elif module == 'sqli':
                pass
            elif module == 'xss':
                pass
            elif module == 'fileupload':
                # Get all the resources first
                resources = self.resourceHandler(
                    'GET', {"vulnType": "File Upload", "resType": "File"})
                for key in dirURL:
                    for url in dirURL[key]:
                        a = FileUpload(url, resources)
                        a.main()
            elif module == 'idor':
                pass
            elif module == 'pathtraversal':
                pass
            else:
                raise ValueError(f'Invalid module {module}')
        if commands != []:
            utils.multiprocess('result.txt', *commands)
        else:
            utils.log('Error: No module is selected', "ERROR")
            return 'Failed'

    def resourceHandler(self, method, data):
        """Handle the resources.

        :param method: `GET` or `POST`
        :param data: JSON object. The format of the JSON object is as follows:
        - GET: `{"vulnType": "", "resType": "}`
        - POST: `{"vulnType": "", "resType": "", "value": "", "action": ""}` with `"action"` is either `"add"`, `"remove"` or `"update"`
        """
        if method not in ['GET', 'POST']:
            utils.log(f'Error: {method} is not a valid method', "ERROR")
            return 'Failed'
        # Parse JSON object
        if method == 'GET':
            if 'vulnType' in data.keys() and 'resType' in data.keys() and len(data.keys()) == 2:
                query = {}
                if data['vulnType'] != "":
                    query['vulnType'] = data['vulnType']
                if data['resType'] != "":
                    query['type'] = data['resType']
                cursor = self.__database.findDocument('resources', query)
                listResult = []
                for item in cursor:
                    listResult.append(item)
                if cursor.retrieved == 0:
                    utils.log('Error: No data found', "ERROR")
                    return 'Failed'
                return listResult
            else:
                utils.log('Error: Invalid JSON object', "ERROR")
                return 'Failed'
        elif method == 'POST':
            if 'vulnType' in data.keys() and 'resType' in data.keys() and 'value' in data.keys() and 'action' in data.keys() and len(data.keys()) == 4:  # refactor later
                action = data['action']
                if action == 'add':
                    # Note: if the value is a file, it must be encoded in base64 string before sending to the server (client side)
                    newDocument = {
                        "vulnType": data['vulnType'],
                        "type": data['resType'],
                        "value": data['value'],
                        "createdDate": datetime.now(),
                        "editedDate": datetime.now()
                    }
                    state = self.__database.addDocument(
                        'resources', newDocument)
                    if state == 'Failed':
                        utils.log('Error: Cannot add the document', "ERROR")
                        return 'Failed'
                    return 'Success'
                elif action == 'remove':
                    state = self.__database.deleteDocument('resources', {
                                                           'vulnType': data['vulnType'], 'type': data['resType'], 'value': data['value']})
                    if state == 'Failed':
                        utils.log(
                            'Error: Cannot delete the document', "ERROR")
                        return 'Failed'
                    return 'Success'
                elif action == 'update':
                    state = self.__database.updateDocument('resources', {
                                                           'vulnType': data['vulnType'], 'type': data['resType']}, {'$set': {'value': data['value']}})
                    if state == 'Failed':
                        utils.log(
                            'Error: Cannot update the document', "ERROR")
                        return 'Failed'
                    return 'Success'
            else:
                utils.log('Error: Invalid JSON object', "ERROR")
                return 'Failed'

    def getScanResult(self, method, data):
        """Get all the scan results from the database.

        :param method: GET
        :param data: JSON object
        """
        if method != 'GET':
            utils.log(f'Error: {method} is not a valid method', "ERROR")
            return 'Failed'
        # Parse JSON object
        if method == 'GET':
            if 'domain' in data.keys() and 'scanDate' in data.keys() and len(data.keys()) == 2:
                query = {}
                if data['domain'] != "":
                    query['domain'] = data['domain']
                if data['scanDate'] != "":
                    dateParsed = datetime.strptime(
                        data['scanDate'], "%Y-%m-%dT%H:%M:%S.%fZ")
                    query['scanDate'] = dateParsed
                cursor = self.__database.findDocument('scanResult', query)
                listResult = []
                for item in cursor:
                    listResult.append(item)
                if cursor.retrieved == 0:
                    utils.log('Error: No data found', "ERROR")
                    return 'Failed'
                return str(listResult)
            else:
                utils.log('Error: Invalid JSON object', "ERROR")
                return 'Failed'

    def saveScanResult(self, data):
        """Save scan result to the database.

        :param data: JSON object
        """
        state = self.__database.addDocument('scanResult', data)
        if state == 'Failed':
            utils.log('Error: Cannot add the document', "ERROR")
            return 'Failed'
        return 'Success'
