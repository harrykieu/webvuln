from flask import Flask
from flask import request
from . import backend as be
from . import utils


app = Flask(__name__)
backend = be.WebVuln()
# Debug
backend.setDebug(True)

# Note: the Content-Type header must be set to `application/json` for the request to be parsed correctly.
# Note: the Origin header must be set to match the sender's origin ('backend' or 'frontend').

@app.post('/api/scan')
def scan():
    """Scan a website.

    This function is used for frontend to scan a website using `/api/scan` endpoint with `POST`.

    The request body should contain a JSON object with the following properties:
    - `url`: The URL of the website.
    - `modules`: The name of the modules to use for the scan.
    """
    orgHeader = request.headers.get('Origin')
    if orgHeader != 'frontend':
        if app.debug:
            utils.log("/api/scan: Missing or invalid Origin header", "DEBUG")    
        return "Forbidden", 403
    contHeader = request.headers.get('Content-Type')
    if contHeader != 'application/json':
        if app.debug:
            utils.log("/api/scan: Missing or invalid Content-Type header", "DEBUG")
        return "Bad request", 400
    data = request.get_json()
    if not data:
        if app.debug:
            utils.log("/api/scan: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400
    keys = data.keys()
    if 'url' in keys and 'modules' in keys and len(keys) == 2:
        if app.debug:
            utils.log(f"/api/scan: Successfully received data: {data}", "DEBUG")
        backend.recvFlask('/api/scan', 'POST', data)
        return "Success", 200
    else:
        if app.debug:
            utils.log("/api/scan: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400

@app.get('/api/history')
def history():
    """Get scan history.
    
    This function is used for frontend to get scan history using `/api/history` endpoint with `GET`.

    The request body should contain a JSON object with the following properties:
    - `url`: The URL of the website.
    - `date`: The date of the scan.
    """
    orgHeader = request.headers.get('Origin')
    if orgHeader != 'frontend':
        if app.debug:
            utils.log("/api/history: Missing or invalid Origin header", "DEBUG")
        return "Forbidden", 403
    contHeader = request.headers.get('Content-Type')
    if contHeader != 'application/json':
        if app.debug:
            utils.log("/api/history: Missing or invalid Content-Type header", "DEBUG")
        return "Bad request", 400
    data = request.get_json()
    if not data:
        if app.debug:
            utils.log("/api/history: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400
    keys = data.keys()
    if 'url' in keys and 'date' in keys and len(keys) == 2:
        if app.debug:
            utils.log(f"/api/history: Successfully received data: {data}", "DEBUG")
        backend.recvFlask('/api/history', 'GET', data)
        return "Success", 200
    else:
        if app.debug:
            utils.log("/api/history: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400

@app.post('/api/resources')
def postResources():
    """Create/Update/Remove a resource.

    This function is used for frontend to create, update, or remove a resource using `/api/resources` endpoint with `POST`.

    The request body should contain a JSON object with the following properties:
    - `vulnType`: Type of vulnerability (e.g. XSS, SQLi, etc.)
    - `type`: Type of resource (e.g. payload, exploit, etc.)
    - `value`: Value of the resource (e.g. payload, exploit, etc.)
    - `action`: Action to perform (e.g. create, update, remove)
    """
    orgHeader = request.headers.get('Origin')
    if orgHeader != 'frontend':
        if app.debug:
            utils.log("/api/resources: Missing or invalid Origin header", "DEBUG")
        return "Forbidden", 403
    contHeader = request.headers.get('Content-Type')
    if contHeader != 'application/json':
        if app.debug:
            utils.log("/api/resources: Missing or invalid Content-Type header", "DEBUG")
        return "Bad request", 400
    data = request.get_json()
    if not data:
        if app.debug:
            utils.log("/api/resources: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400
    keys = data.keys()
    if 'vulnType' in keys and 'type' in keys and 'value' in keys and 'action' in keys and len(keys) == 4:
        if app.debug:
            utils.log(f"/api/resources: Successfully received data: {data}", "DEBUG")
        backend.recvFlask('/api/resources', 'POST', data)
        return "Success", 200
    else:
        if app.debug:
            utils.log("/api/resources: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400

@app.get('/api/resources')
def getResources():
    """Get resources.
    
    This function is used for frontend to get resource using `/api/resources` endpoint with `GET`.

    The request body should contain a JSON object with the following properties:
    - `vulnType`: Type of vulnerability (e.g. XSS, SQLi, etc.)
    - `type`: Type of resource (e.g. payload, exploit, etc.) - has `All` type
    """
    orgHeader = request.headers.get('Origin')
    if orgHeader != 'frontend':
        if app.debug:
            utils.log("/api/resources: Missing or invalid Origin header", "DEBUG")
        return "Forbidden", 403
    contHeader = request.headers.get('Content-Type')
    if contHeader != 'application/json':
        if app.debug:
            utils.log("/api/resources: Missing or invalid Content-Type header", "DEBUG")
        return "Bad request", 400
    data = request.get_json()
    if not data:
        if app.debug:
            utils.log("/api/resources: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400
    keys = data.keys()
    if 'vulnType' in keys and 'type' in keys and len(keys) == 2:
        if app.debug:
            utils.log(f"/api/resources: Successfully received data: {data}", "DEBUG")
        backend.recvFlask('/api/resources', 'GET', data)
        return "Success", 200
    else:
        if app.debug:
            utils.log("/api/resources: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400
    
@app.post('/api/result')
def postResult():
    """Create/Update/Remove a result.

    This function is used for backend to create, update, or remove a result using `/api/result` endpoint with `POST`.

    The request body should contain a JSON object with the following properties:
    - `result`: Result of the scan.
    """
    orgHeader = request.headers.get('Origin')
    if orgHeader != 'backend':
        if app.debug:
            utils.log("/api/result: Missing or invalid Origin header", "DEBUG")
        return "Forbidden", 403
    contHeader = request.headers.get('Content-Type')
    if contHeader != 'application/json':
        if app.debug:
            utils.log("/api/result: Missing or invalid Content-Type header", "DEBUG")
        return "Bad request", 400
    data = request.get_json()
    if not data:
        if app.debug:
            utils.log("/api/result: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400
    keys = data.keys()
    if 'result' in keys and len(keys) == 1:
        if app.debug:
            utils.log(f"/api/result: Successfully received data: {data}", "DEBUG")
        backend.recvFlask('/api/result', 'POST', data)
        return "Success", 200
    else:
        if app.debug:
            utils.log("/api/result: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400

if __name__ == '__main__':
    app.run(debug=True, use_reloader=False)