from flask import Flask
from flask import request
from main import WebVuln
app = Flask(__name__)

backend = WebVuln()
# Note: the Content-Type header must be set to application/json for the request to be parsed correctly.
# Note: the Origin header must be set to match the sender's origin ('backend' or 'frontend').

@app.post('/api/scan')
def scan():
    """Scan a website.

    This function is used for frontend to scan a website using `/api/scan` endpoint with `POST`.

    The request body should contain a JSON object with the following properties:
    - `url`: The URL of the website.
    - `modules`: The name of the modules to use for the scan.
    """
    header = request.headers.get('Origin')
    if header != 'frontend':
        return "Forbidden", 403
    return "Scan successful, will send to backend later" 
    """ data = request.get_json()
    url = data['url']
    return backend.scan(url) # fix later
 """
@app.get('/api/history')
def history():
    """Get scan history.
    
    This function is used for frontend to get scan history using `/api/history` endpoint with `GET`.

    The request body should contain a JSON object with the following properties:
    - `url`: The URL of the website.
    - `date`: The date of the scan.
    """
    header = request.headers.get('Origin')
    if header != 'frontend':
        return "Forbidden", 403
    
    """ data = request.get_json()
    url = data['url']
    date = data['date']
    return "Get history successful, will send to backend later"
    return backend.history(url, date) #fix later """

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
    header = request.headers.get('Origin')
    if header != 'frontend':
        return "Forbidden", 403
    data = request.get_json()
    if not data:
        return "Bad request", 400
    keys = data.keys()
    if 'vulnType' in keys and 'type' in keys and 'value' in keys and 'action' in keys and len(keys) == 4:
        vulnType = data['vulnType']
        type = data['type']
        value = data['value']
        action = data['action']
        return f'{vulnType} {type} {value} {action}'
        #return resources(vulnType, type, value, action) #fix later 
    else:
        return "Bad request", 400

@app.get('/api/resources')
def getResources():
    """Get resources.
    
    This function is used for frontend to get resource using `/api/resources` endpoint with `GET`.

    The request body should contain a JSON object with the following properties:
    - `vulnType`: Type of vulnerability (e.g. XSS, SQLi, etc.)
    - `type`: Type of resource (e.g. payload, exploit, etc.)
    """
    header = request.headers.get('Origin')
    if header != 'frontend':
        return "Forbidden", 403
    return "Get resources successful, will send to backend later"
    """ data = request.get_json()
    vulnType = data['vulnType']
    type = data['type']
    return backend.getResources(vulnType, type) #fix later """
    
@app.post('/api/result')
def postResult():
    """Create/Update/Remove a result.

    This function is used for backend to create, update, or remove a result using `/api/result` endpoint with `POST`.

    The request body should contain a JSON object with the following properties:
    - `result`: Result of the scan.
    """
    header = request.headers.get('Origin')
    if header != 'backend':
        return "Forbidden", 403
    data = request.get_json()
    return "Post result successful, will send to frontend later"
    """ result = data['result']
    return backend.postResult(result) """

if __name__ == '__main__':
    app.run()