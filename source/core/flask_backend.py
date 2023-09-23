from flask import Flask
from flask import request

app = Flask(__name__)

@app.post('/recv')
def recv():
    url = request.form['url']
    print(url)
    return url

if __name__ == '__main__':
    app.run()