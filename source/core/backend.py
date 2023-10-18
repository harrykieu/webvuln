import base64
from datetime import *
import os
import requests
import json
import source.core.utils as utils
from pathlib import Path
from database.dbutils import DatabaseUtils
from bson.binary import Binary
from bson.json_util import dumps, loads
import pymongo

ROOTPATH = Path(__file__).parent.parent.parent


class WebVuln:
    def __init__(self) -> None:
        self.__debug = False
        self.__database = DatabaseUtils()

    def setDebug(self, debug: bool) -> None:
        self.__debug = debug

    def getDebug(self) -> bool:
        return self.__debug

    def sendFlask(self, data):
        route = '/api/result'
        # Checking the keys required for the request
        keys = json.loads(data).keys()
        if 'result' in keys and len(keys) == 1:
            try:
                if self.__debug:
                    utils.log(
                        f'/api/result: Sending data to Flask: {data}', "DEBUG")
                requests.post(url=f'http://localhost:5000/{route}', data=data, headers={
                              'Content-Type': 'application/json', 'Origin': 'backend'})
            except Exception as e:
                utils.log(f'Error: {e}', "ERROR")
                return e

    def recvFlask(self, route, method,  jsonData) -> None:
        if self.__debug:
            print(f'{method} {route}: {jsonData.keys()}')
        pass

    def scanURL(self, urls):
        commands = []
        jsonFiles = []
        dirURL = {}
        for url in urls:
            filename = f'scanresult_url{urls.index(url)}.json'
            jsonFiles.append(filename)
            # FFUF or Dirsearch?
            # commands.append(f'{ROOTPATH}/source/tools/public/ffuf/ffuf.exe -u {url}/FUZZ -w {ROOTPATH}/source/tools/public/ffuf/fuzz-Bo0oM.txt -of json -o {filename} -p 0.2 -mc 200')
            commands.append(
                f'python {ROOTPATH}/source/tools/public/dirsearch/dirsearch.py -u {url} -w {ROOTPATH}/source/tools/public/ffuf/fuzz-Bo0oM.txt -t 50 --format=json -x 404 -o {filename}')
            utils.multiprocess('result.txt', *commands)
            for jsonFile in jsonFiles:
                with open(jsonFile, 'r') as f:
                    data = json.load(f)
                    for res in data["results"]:
                        if not f'{url}' in dirURL.keys():
                            dirURL[f'{url}'] = []
                        dirURL[f'{url}'].append(res['url'])
                f.close()
                os.remove(jsonFile)
        # Missing choosing scan modules???
        print(dirURL)

    def resourceHandler(self, method, data):
        if method not in ['GET','POST']:
            utils.log(f'Error: {method} is not a valid method', "ERROR")
            return 'Failed'
        # Parse JSON object
        jsonData = json.loads(data)
        if method == 'GET':
            if 'vulnType' in jsonData.keys() and 'resType' in jsonData.keys() and len(jsonData.keys()) == 2: #refactor later
                query = self.__database.findDocument('resources', {'vulnType': jsonData['vulnType'],'type': jsonData['resType']})
                listResult = []
                for item in query:
                    listResult.append(item)
                if query.retrieved == 0:
                    utils.log(f'Error: No data found', "ERROR")
                    return 'Failed'
                return listResult
            else:
                utils.log(f'Error: Invalid JSON object', "ERROR")
                return 'Failed'
        elif method == 'POST':
            if 'vulnType' in jsonData.keys() and 'resType' in jsonData.keys() and 'value' in jsonData.keys() and 'action' in jsonData.keys() and len(jsonData.keys()) == 4: #refactor later
                action = jsonData['action']
                if action == 'add':
                    # Note: if the value is a file, it must be encoded in base64 string before sending to the server (client side)
                    newDocument = {
                        "vulnType": jsonData['vulnType'],
                        "type": jsonData['resType'],
                        "value": jsonData['value'],
                        "createdDate": datetime.now(),
                        "editedDate": datetime.now()
                    }
                    state = self.__database.addDocument('resources', newDocument)
                    if state == 'Failed':
                        utils.log(f'Error: Cannot add the document', "ERROR")
                        return 'Failed'
                    return 'Success'
                elif action == 'remove':
                    state = self.__database.deleteDocument('resources', {'vulnType': jsonData['vulnType'],'type': jsonData['resType'],'value': jsonData['value']})
                    if state == 'Failed':
                        utils.log(f'Error: Cannot delete the document', "ERROR")
                        return 'Failed'
                    return 'Success'
                elif action == 'update':
                    state = self.__database.updateDocument('resources', {'vulnType': jsonData['vulnType'],'type': jsonData['resType']}, {'$set': {'value': jsonData['value']}})
                    if state == 'Failed':
                        utils.log(f'Error: Cannot update the document', "ERROR")
                        return 'Failed'
                    return 'Success'
            else:
                utils.log(f'Error: Invalid JSON object', "ERROR")
                return 'Failed'

    def scanResultHandler(self, method, data):
        #FIX
        if method not in ['GET','POST']:
            utils.log(f'Error: {method} is not a valid method', "ERROR")
            return 'Failed'
        # Parse JSON object
        jsonData = json.loads(data)
        if method == 'GET':
            # if 'vulnType' in jsonData.keys() and 'resType' in jsonData.keys() and len(jsonData.keys()) == 2:
            pass
a = WebVuln()
""" obj = {}
obj['vulnType'] = 'File Upload'
obj['resType'] = 'File'
with open(f'{ROOTPATH}/source/tools/self_made/fileupload/fileupload.png', 'rb') as f:
    obj['value'] = base64.b64encode(f.read()).decode()
f.close()
obj['action'] = 'add'
print(obj)
jsonData = dumps(obj)
print(jsonData)
print(a.resourceHandler('POST', jsonData)) """
data = {'vulnType': 'File Upload', 'resType': 'File'}
jsonData = dumps(data)
resbig = a.resourceHandler('GET', jsonData)
for res in resbig:
    filecontentb64 = res['value']
# save file
with open(f'{ROOTPATH}/source/tools/self_made/fileupload/test2.jpg', 'wb') as f:
    f.write(base64.b64decode(filecontentb64))
