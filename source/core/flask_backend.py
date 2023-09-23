from flask import Flask
from flask import request
from main import WebVuln
app = Flask(__name__)

backend = WebVuln()
@app.post('/recv')
def recv():
    data = request.form
    print(data)
    url = request.form['url']
    origin = request.form['ComeFrom']
    backend.handleData(url)
    return url

if __name__ == '__main__':
    app.run()