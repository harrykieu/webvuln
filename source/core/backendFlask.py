from flask import Flask
from flask import request
from source.core.backend import WebVuln
import source.core.utils as utils


app = Flask(__name__)
backend = WebVuln()
# Debug
backend.setDebug(True)

# Note: the Content-Type header must be set to `application/json` for the request to be parsed correctly.f
# Note: the Origin header must be set to match the sender's origin ('backend' or 'frontend').


@app.post("/api/scan")
def scan():
    """Scan a website.

    This function is used for frontend to scan a website using `/api/scan` endpoint with `POST`.

    The request body should contain a JSON object with the following properties:
    - `urls`: The URL of the website.
    - `modules`: The name of the modules to use for the scan.
    """
    orgHeader = request.headers.get("Origin")
    if orgHeader != "frontend":
        if app.debug:
            utils.log("/api/scan: Missing or invalid Origin header", "DEBUG")
        return "Forbidden", 403
    contHeader = request.headers.get("Content-Type")
    if contHeader != "application/json":
        if app.debug:
            utils.log("/api/scan: Missing or invalid Content-Type header", "DEBUG")
        return "Bad request", 400
    data = request.get_json()
    if not data:
        if app.debug:
            utils.log("/api/scan: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400
    keys = data.keys()
    if "urls" in keys and "modules" in keys and len(keys) == 2:
        if app.debug:
            utils.log(f"/api/scan: Successfully received data: {data}", "DEBUG")
        backend.recvFlask("/api/scan", "POST", data)
        return "Success", 200
    else:
        if app.debug:
            utils.log("/api/scan: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400


@app.get("/api/history")
def history():
    """Get scan history.

    This function is used for frontend to get scan history using `/api/history` endpoint with `GET`.

    The request body should contain a JSON object with the following properties:
    - `domain`: The URL of the website.
    - `scanDate`: The date of the scan, in format `%Y-%m-%dT%H:%M:%S.%fZ`, example: `2023-09-23T09:31:41.274Z`
    """
    orgHeader = request.headers.get("Origin")
    if orgHeader != "frontend":
        if app.debug:
            utils.log("/api/history: Missing or invalid Origin header", "DEBUG")
        return "Forbidden", 403
    contHeader = request.headers.get("Content-Type")
    if contHeader != "application/json":
        if app.debug:
            utils.log("/api/history: Missing or invalid Content-Type header", "DEBUG")
        return "Bad request", 400
    data = request.get_json()
    if not data:
        if app.debug:
            utils.log("/api/history: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400
    keys = data.keys()
    if "domain" in keys and "scanDate" in keys and len(keys) == 2:
        if app.debug:
            utils.log(f"/api/history: Successfully received data: {data}", "DEBUG")
        result = backend.recvFlask("/api/history", "GET", data)
        if result == "Failed":
            utils.log("/api/history: Failed to get scan history", "ERROR")
            return "Failed", 404
        else:
            return result, 200
    else:
        if app.debug:
            utils.log("/api/history: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400


@app.post("/api/resourcesnormal")
def postResources():
    """Create/Update/Remove a normal (string) resource.

    This function is used for frontend to create, update, or remove a resource using `/api/resourcesnormal` endpoint with `POST`.

    The request body should contain a JSON object with the following properties:
    - `vulnType`: Type of vulnerability (e.g. XSS, SQLi, etc.)
    - `resType`: Type of resource (e.g. payload, exploit, etc.)
    - `value`: Value of the resource (e.g. payload, exploit, etc.)
    - `action`: Action to perform (e.g. create, update, remove)
    """
    orgHeader = request.headers.get("Origin")
    if orgHeader != "frontend":
        if app.debug:
            utils.log("/api/resourcesnormal: Missing or invalid Origin header", "DEBUG")
        return "Forbidden", 403
    contHeader = request.headers.get("Content-Type")
    if contHeader != "application/json":
        if app.debug:
            utils.log(
                "/api/resourcesnormal: Missing or invalid Content-Type header", "DEBUG"
            )
        return "Bad request", 400
    data = request.get_json()
    if not data:
        if app.debug:
            utils.log("/api/resourcesnormal: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400
    keys = data.keys()
    if (
        "vulnType" in keys
        and "resType" in keys
        and "value" in keys
        and "action" in keys
        and len(keys) == 4
    ):
        if app.debug:
            utils.log(
                f"/api/resourcesnormal: Successfully received data: {data}", "DEBUG"
            )
        backend.recvFlask("/api/resourcesnormal", "POST", data)
        return "Success", 200
    else:
        if app.debug:
            utils.log("/api/resourcesnormal: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400


@app.get("/api/resourcesnormal")
def getResources():
    """Get resources.

    This function is used for frontend to get resource using `/api/resourcesnormal` endpoint with `GET`.

    The request body should contain a JSON object with the following properties:
    - `vulnType`: Type of vulnerability (e.g. XSS, SQLi, etc.) - `All` value to find all resources
    - `resType`: Type of resource (e.g. payload, exploit, etc.) - `All` value to find all resources
    """
    orgHeader = request.headers.get("Origin")
    if orgHeader != "frontend":
        if app.debug:
            utils.log("/api/resourcesnormal: Missing or invalid Origin header", "DEBUG")
        return "Forbidden", 403
    contHeader = request.headers.get("Content-Type")
    if contHeader != "application/json":
        if app.debug:
            utils.log(
                "/api/resourcesnormal: Missing or invalid Content-Type header", "DEBUG"
            )
        return "Bad request", 400
    data = request.get_json()
    if not data:
        if app.debug:
            utils.log("/api/resourcesnormal: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400
    keys = data.keys()
    if "vulnType" in keys and "resType" in keys and len(keys) == 2:
        if app.debug:
            utils.log(
                f"/api/resourcesnormal: Successfully received data: {data}", "DEBUG"
            )
        result = backend.recvFlask("/api/resourcesnormal", "GET", data)
        if result == "Failed":
            utils.log("/api/resourcesnormal: Failed to get resources", "ERROR")
            return "Failed", 404
        else:
            return result, 200
    else:
        if app.debug:
            utils.log("/api/resourcesnormal: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400


# FIX


@app.get("/api/resourcesfile")
def getResourcesFile():
    """Get files for file upload module.

    This function is used for frontend to get file resource using `/api/resourcesfile` endpoint with `GET` (especially for file upload module).

    The request body should contain a JSON object with the following properties:
    - `description`: Step of the file upload module (e.g. valid, invalidbutvalidExtension, invalidbutvalidMH)
    """
    orgHeader = request.headers.get("Origin")
    if orgHeader != "frontend":
        if app.debug:
            utils.log("/api/resourcesfile: Missing or invalid Origin header", "DEBUG")
        return "Forbidden", 403
    contHeader = request.headers.get("Content-Type")
    if contHeader != "application/json":
        if app.debug:
            utils.log(
                "/api/resourcesfile: Missing or invalid Content-Type header", "DEBUG"
            )
        return "Bad request", 400
    data = request.get_json()
    if not data:
        if app.debug:
            utils.log("/api/resourcesfile: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400
    keys = data.keys()
    if "description" in keys and len(keys) == 1:
        if app.debug:
            utils.log(
                f"/api/resourcesfile: Successfully received data: {data}", "DEBUG"
            )
        result = backend.recvFlask("/api/resourcesfile", "GET", data)
        if result == "Failed":
            utils.log("/api/resourcesfile: Failed to get resources", "ERROR")
            return "Failed", 404
        else:
            return result, 200
    else:
        if app.debug:
            utils.log("/api/resourcesfile: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400


# Fix


@app.post("/api/resourcesfile")
def postResourcesFile():
    """Create/Update/Remove a file resource.

    This function is used for frontend to create, update, or remove a file resource using `/api/resourcesfile` endpoint with `POST` (especially for file upload module).

    The request body should contain a JSON object with the following properties:
    - `fileName`: Name of the file.
    - `description`: Description of the file.
    - `base64value`: The base64 value of the file.
    - `action`: Action to perform (e.g. create, update, remove)
    """
    orgHeader = request.headers.get("Origin")
    if orgHeader != "frontend":
        if app.debug:
            utils.log("/api/resourcesnormal: Missing or invalid Origin header", "DEBUG")
        return "Forbidden", 403
    contHeader = request.headers.get("Content-Type")
    if contHeader != "application/json":
        if app.debug:
            utils.log(
                "/api/resourcesnormal: Missing or invalid Content-Type header", "DEBUG"
            )
        return "Bad request", 400
    data = request.get_json()
    if not data:
        if app.debug:
            utils.log("/api/resourcesnormal: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400
    keys = data.keys()
    if (
        "fileName" in keys
        and "description" in keys
        and "base64value" in keys
        and "action" in keys
        and len(keys) == 4
    ):
        if app.debug:
            utils.log(
                f"/api/resourcesnormal: Successfully received data: {data}", "DEBUG"
            )
        backend.recvFlask("/api/resourcesnormal", "POST", data)
        return "Success", 200
    else:
        if app.debug:
            utils.log("/api/resourcesnormal: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400


@app.post("/api/result")
def postResult():
    """Create/Update/Remove a result.

    This function is used for backend to create, update, or remove a result using `/api/result` endpoint with `POST`.

    The request body should contain a JSON object with the following properties:
    - `result`: Result of the scan.
    """
    orgHeader = request.headers.get("Origin")
    if orgHeader != "backend":
        if app.debug:
            utils.log("/api/result: Missing or invalid Origin header", "DEBUG")
        return "Forbidden", 403
    contHeader = request.headers.get("Content-Type")
    if contHeader != "application/json":
        if app.debug:
            utils.log("/api/result: Missing or invalid Content-Type header", "DEBUG")
        return "Bad request", 400
    data = request.get_json()
    if not data:
        if app.debug:
            utils.log("/api/result: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400
    keys = data.keys()
    if "result" in keys and len(keys) == 1:  # FIX LATER
        if app.debug:
            utils.log(f"/api/result: Successfully received data: {data}", "DEBUG")
        # frontend.recvFlask('/api/result', 'POST', data)
        return "Success", 200
    else:
        if app.debug:
            utils.log("/api/result: Missing or invalid JSON data", "DEBUG")
        return "Bad request", 400


if __name__ == "__main__":
    app.run(debug=True, use_reloader=False)
