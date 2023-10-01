import requests
import json
from . import utils

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
