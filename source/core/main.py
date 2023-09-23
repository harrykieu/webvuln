import requests

class WebVuln:
    def __init__(self) -> None:
        pass

    def sendFlask(self, data, route):
        try:
            r = requests.post(route, data=data)
            return r
        except Exception as e:
            return e
    
    def recvFlask(self,route):
        try:
            r = requests.get(route)
            return r
        except Exception as e:
            return e
    
inst = WebVuln()
inst.sendFlask(data={'url':'http://sus.com'}, route='http://localhost:5000/recv')