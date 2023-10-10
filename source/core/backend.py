import os
import requests
import json
import utils
from pathlib import Path
import tempfile

ROOTPATH = Path(__file__).parent.parent.parent

class WebVuln:
    def __init__(self) -> None:
        self.__debug = False
    
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
                    utils.log(f'/api/result: Sending data to Flask: {data}', "DEBUG")
                requests.post(url=f'http://localhost:5000/{route}', data=data, headers={'Content-Type': 'application/json', 'Origin': 'backend'})
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
            #commands.append(f'{ROOTPATH}/source/tools/public/ffuf/ffuf.exe -u {url}/FUZZ -w {ROOTPATH}/source/tools/public/ffuf/fuzz-Bo0oM.txt -of json -o {filename} -p 0.2 -mc 200')
            commands.append(f'python {ROOTPATH}/source/tools/public/dirsearch/dirsearch.py -u {url} -w {ROOTPATH}/source/tools/public/ffuf/fuzz-Bo0oM.txt -t 50 --format=json -x 404 -o {filename}')
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
        print(dirURL)
        
a = WebVuln()
a.scanURL(['http://localhost/dvwa'])