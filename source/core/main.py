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
    
    def handleData(self, data):
        print(data)

#test
inst = WebVuln()
inst.sendFlask(data={'url':'http://sus.com', 'ComeFrom':'WebVuln'}, route='http://localhost:5000/recv')