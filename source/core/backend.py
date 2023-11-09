import json
import os
from datetime import datetime
from pathlib import Path
import pymongo

import requests
from source.core.database.dbutils import DatabaseUtils
import source.core.utils as utils
from source.tools.self_made.fileupload.fileupload import FileUpload
from source.tools.self_made.pathtraversal.pathtraversal import PathTraversal

ROOTPATH = Path(__file__).parent.parent.parent
MODULES = [
    "ffuf",
    "dirsearch",
    "lfi",
    "sqli",
    "xss",
    "fileupload",
    "idor",
    "pathtraversal",
]


class WebVuln:
    def __init__(self) -> None:
        self.__debug = False
        self.__database = DatabaseUtils()

    def setDebug(self, debug: bool) -> None:
        self.__debug = debug

    def getDebug(self) -> bool:
        return self.__debug

    def sendResultFlask(self, data) -> str:
        """Send data to Flask.

        :param data: JSON object"""
        keys = json.loads(data).keys()
        if "result" in keys and len(keys) == 1:
            try:
                if self.__debug:
                    utils.log(f"/api/result: Sending data to Flask: {data}", "DEBUG")
                requests.post(
                    url="http://localhost:5000/api/result",
                    data=data,
                    headers={"Content-Type": "application/json", "Origin": "backend"},
                )
            except Exception as e:
                if self.__debug:
                    print(f"[backend.py-sendResultFlask] Error: {e}")
                utils.log(f"[backend.py-sendResultFlask] Error: {e}", "ERROR")
                return "Failed"
            return "Success"

    def recvFlask(self, route, method, jsonData) -> None | str:
        """Receive data from Flask based on the route.

        :param route: The route of the request
        :param method: `GET` or `POST`
        :param jsonData: JSON object
        """
        if self.__debug:
            print(f"{method} {route}: {jsonData.keys()}")
        if route == "/api/history":
            return self.getScanResult(method, jsonData)
        elif route == "/api/resourcesnormal":
            return self.resourceHandler(method, jsonData)
        elif route == "/api/resourcesfile":
            return self.fileHandler(method, jsonData)
        elif route == "/api/scan":
            return self.scanURL(jsonData["urls"])
        else:
            utils.log(f"Error: Invalid route {route}", "ERROR")
            return "Failed"

    def scanURL(self, urls, modules):
        """Scan the URLs.

        :param urls: List of URLs
        :param modules: List of modules
        The return json will have the following format:
        ```
        {
            "result": [
                "url1":  {
                    "module": "vulnerable/not vulnerable"
                },
                "url2": {
                    "module": "vulnerable/not vulnerable"
                }
            ]
        }
        ```
        """

        commands = []
        jsonFiles = []
        dirURL = {}
        listResult = []
        if isinstance(urls, list) is False:
            if self.__debug:
                print("[backend.py-scanURL] Error: URLs must be a list")
            utils.log("[backend.py-scanURL] Error: URLs must be a list", "ERROR")
            return "Failed"
        elif isinstance(modules, list) is False:
            if self.__debug:
                print("[backend.py-scanURL] Error: Modules must be a list")
            utils.log("[backend.py-scanURL] Error: Modules must be a list", "ERROR")
            return "Failed"
        if urls == [] or modules == []:
            if self.__debug:
                print("[backend.py-scanURL] Error: URLs and modules must not be empty")
            utils.log(
                "[backend.py-scanURL] Error: URLs and modules must not be empty",
                "ERROR",
            )
            return "Failed"
        for url in urls:
            filename = f"scanresult_url{urls.index(url)}.json"
            jsonFiles.append(filename)
            # For using ffuf and dirsearch (if needed)
            if "ffuf" in modules:
                modules.pop(modules.index("ffuf"))
                print('[-] Running ffuf...')
                commands.append(
                    f"{ROOTPATH}/source/tools/public/ffuf/ffuf.exe -u {url}/FUZZ -w {ROOTPATH}/source/tools/public/ffuf/fuzz-Bo0oM.txt -of json -o {filename} -p 0.2 -mc 200,301"
                )
            elif "dirsearch" in modules:
                modules.pop(modules.index("dirsearch"))
                print('[-] Running dirsearch...')
                commands.append(
                    f"python {ROOTPATH}/source/tools/public/dirsearch/dirsearch.py -u {url} -w {ROOTPATH}/source/tools/public/ffuf/fuzz-Bo0oM.txt -t 50 --format=json -x 404 -o {filename}"
                )
            if commands != []:
                utils.multiprocess("result.txt", *commands)
                for jsonFile in jsonFiles:
                    with open(jsonFile, "r") as f:
                        data = json.load(f)
                        for res in data["results"]:
                            if f"{url}" not in dirURL.keys():
                                dirURL[f"{url}"] = []
                            dirURL[f"{url}"].append(res["url"])
                    f.close()
                    os.remove(jsonFile)
            else:
                dirURL[f"{url}"] = [f"{url}"]
            os.remove("result.txt")
            print(f'[!] All URLs: {dirURL}')
        for module in modules:
            if module == "lfi":
                print('[+] Checking LFI vulnerability...')
                pass
            elif module == "sqli":
                print('[+] Checking SQLi vulnerability...')
                pass
            elif module == "xss":
                print('[+] Checking XSS vulnerability...')
                pass
            elif module == "fileupload":
                print('[+] Checking file upload vulnerability...')
                resources = self.fileHandler("GET", {"description": ""})
                if resources == "Failed":
                    utils.log(
                        "[backend.py-scanURL] Error: Failed to get resources", "ERROR"
                    )
                    if self.__debug:
                        print("[backend.py-scanURL] Error: Failed to get resources")
                    return "Failed"
                # TODO: FIX THE LOGIC?
                for key in dirURL:
                    resultURL = {
                        "domain": key,
                        "scanDate": datetime.now(),
                        "numVuln": 0,
                        "vulnerabilities": [],
                    }
                    for url in dirURL[key]:
                        if 'dvwa' in url:
                            a = FileUpload(url, resources, isDVWA=True)
                        else:
                            a = FileUpload(url, resources)
                        vuln = a.main()
                        if vuln is True:
                            resultURL["numVuln"] += 1
                            resultURL["vulnerabilities"].append(
                                {
                                    "type": "File Upload",
                                    "description": f"{url} is vulnerable to file upload",
                                    "severity": "High",
                                }
                            )
                            if self.__debug:
                                print(
                                    f"[backend.py-scanURL] {url} is vulnerable to file upload"
                                )
                            utils.log(
                                f"[backend.py-scanURL] {url} is vulnerable to file upload",
                                "INFO",
                            )
                        else:
                            if self.__debug:
                                print(
                                    f"[backend.py-scanURL] {url} is not vulnerable to file upload"
                                )
                            utils.log(
                                f"[backend.py-scanURL] {url} is not vulnerable to file upload",
                                "INFO",
                            )
                        listResult.append(resultURL)
                print(listResult)
            elif module == "idor":
                print('[+] Checking IDOR vulnerability...')
                pass
            elif module == "pathtraversal":
                print('[+] Checking path traversal vulnerability...')
                resources = self.resourceHandler(
                    'GET', {"vulnType": "PathTraversal", "resType": "payload"})
                for key in dirURL:
                    for url in dirURL[key]:
                        a = PathTraversal(url, resources)
                        a.scanWebsite()
            else:
                raise ValueError(f"Invalid module {module}")
        for res in listResult:
            res["resultSeverity"] = "High"
            try:
                self.__database.addDocument("scanResult", res)
            except Exception as e:
                if self.__debug:
                    print(f"[backend.py-scanURL] Error: {e}")
                utils.log(f"[backend.py-scanURL] Error: {e}", "ERROR")
                return "Failed"
        result = {"result": listResult}
        try:
            self.sendResultFlask(json.dumps(result, default=str))
        except Exception as e:
            if self.__debug:
                print(f"[backend.py-scanURL] Error: {e}")
            utils.log(f"[backend.py-scanURL] Error: {e}", "ERROR")
            return "Failed"
        return "Success"

    def resourceHandler(self, method, data) -> str | list:
        """Handle the resources.

        :param method: `GET` or `POST`
        :param data: JSON object. The format of the JSON object is as follows:
        - GET: `{"vulnType": "", "resType": "}`
        - POST: `{"vulnType": "", "resType": "", "value": "", "action": ""}` with `"action"` is either `"add"`, `"remove"` or `"update"`
        Note: when the action is `"update"`, the `"value"` field must be the list of the old value and the new value. Example: `{"vulnType": "", "resType": "", "value": ["oldValue", "newValue"], "action": "update"}`
        """
        if method not in ["GET", "POST"]:
            if self.__debug:
                print(
                    f"[backend.py-resourceHandler] Error: {method} is not a valid method"
                )
            utils.log(
                f"[backend.py-resourceHandler] Error: {method} is not a valid method",
                "ERROR",
            )
            return "Failed"
        # Parse JSON object
        if method == "GET":
            if (
                "vulnType" in data.keys()
                and "resType" in data.keys()
                and len(data.keys()) == 2
            ):
                query = {}
                if data["vulnType"] != "":
                    query["vulnType"] = data["vulnType"]
                if data["resType"] != "":
                    query["type"] = data["resType"]
                try:
                    cursor = self.__database.findDocument("resources", query)
                except Exception as e:
                    utils.log(f"[backend.py-findDocument-GET] Error: {e}", "ERROR")
                    if self.__debug:
                        print(f"[backend.py-findDocument-GET] Error: {e}")
                    return "Failed"
                listResult = []
                for item in cursor:
                    listResult.append(item)
                return listResult
            else:
                utils.log("Error: Invalid JSON object", "ERROR")
                return "Failed"
        elif method == "POST":
            if (
                "vulnType" in data.keys()
                and "resType" in data.keys()
                and "value" in data.keys()
                and "action" in data.keys()
                and len(data.keys()) == 4
            ):  # refactor later
                action = data["action"]
                if action == "add":
                    # Note: if the value is a file, it must be encoded in base64 string before sending to the server (client side)
                    newDocument = {
                        "vulnType": data["vulnType"],
                        "type": data["resType"],
                        "value": data["value"],
                        "createdDate": datetime.now(),
                        "editedDate": datetime.now(),
                    }
                    try:
                        self.__database.addDocument("resources", newDocument)
                        return "Success"
                    except Exception as e:
                        if self.__debug:
                            if isinstance(e, pymongo.errors.DuplicateKeyError):
                                print(
                                    "[backend.py-resourceHandler-addDocument] Error: Duplicate key"
                                )
                            else:
                                print(
                                    f"[backend.py-resourceHandler-addDocument] Error: {e}"
                                )
                        utils.log(
                            f"[backend.py-resourceHandler-addDocument] Error: {e}",
                            "ERROR",
                        )
                        return "Failed"
                elif action == "remove":
                    try:
                        self.__database.deleteDocument(
                            "resources",
                            {
                                "vulnType": data["vulnType"],
                                "type": data["resType"],
                                "value": data["value"],
                            },
                        )
                        return "Success"
                    except Exception as e:
                        if self.__debug:
                            print(
                                f"[backend.py-resourceHandler-deleteDocument] Error: {e}"
                            )
                        utils.log(
                            f"[backend.py-resourceHandler-deleteDocument] Error: {e}",
                            "ERROR",
                        )
                        return "Failed"
                elif action == "update":
                    if len(data["value"]) != 2:
                        utils.log(
                            "[backend.py-resourceHandler-updateDocument] Error: Invalid JSON object",
                            "ERROR",
                        )
                        if self.__debug:
                            print(
                                "[backend.py-resourceHandler-updateDocument] Error: Invalid JSON object"
                            )
                        return "Failed"
                    try:
                        self.__database.updateDocument(
                            "resources",
                            {
                                "vulnType": data["vulnType"],
                                "type": data["resType"],
                                "value": data["value"][0],
                            },
                            {"$set": {"value": data["value"][1]}},
                        )
                        return "Success"
                    except Exception as e:
                        utils.log(
                            f"[backend.py-resourceHandler-updateDocument] Error: {e}",
                            "ERROR",
                        )
                        if self.__debug:
                            print(
                                f"[backend.py-resourceHandler-updateDocument] Error: {e}"
                            )
                        return "Failed"
            else:
                utils.log("Error: Invalid JSON object", "ERROR")
                return "Failed"

    def fileHandler(self, method, data) -> str | list:
        """Handle the file resources.

        :param method: `GET` or `POST`
        :param data: JSON object. The format of the JSON object is as follows:
        - GET: `{"description": ""}`
        - POST: `{"fileName": "", "description": "", "base64value": "", "action": ""}` with `"action"` is either `"add"`, `"remove"` or `"update"`.
        The `description` field must be `valid`, `invalidbutvalidExtension` or `invalidbutvalidMH`."""
        if method not in ["GET", "POST"]:
            if self.__debug:
                print(f"[backend.py-fileHandler] Error: {method} is not a valid method")
            utils.log(
                f"[backend.py-fileHandler] Error: {method} is not a valid method",
                "ERROR",
            )
            return "Failed"
        # Parse JSON object
        if method == "GET":
            if "description" in data.keys() and len(data.keys()) == 1:
                query = {}
                if data["description"] != "":
                    query["description"] = data["description"]
                try:
                    cursor = self.__database.findDocument("fileResources", query)
                except Exception as e:
                    if self.__debug:
                        print(f"[backend.py-fileHandler-GET] Error: {e}")
                    return "Failed"
                listResult = []
                for item in cursor:
                    listResult.append(item)
                return listResult
            else:
                if self.__debug:
                    print("[backend.py-fileHandler-GET] Error: Invalid JSON object")
                utils.log(
                    "[backend.py-fileHandler-GET] Error: Invalid JSON object", "ERROR"
                )
                return "Failed"
        elif method == "POST":
            if (
                "fileName" in data.keys()
                and "description" in data.keys()
                and "base64value" in data.keys()
                and "action" in data.keys()
                and len(data.keys()) == 4
            ):
                action = data["action"]
                if action == "add":
                    # Note: if the value is a file, it must be encoded in base64 string before sending to the server (client side)
                    newDocument = {
                        "fileName": data["fileName"],
                        "description": data["description"],
                        "base64value": data["base64value"],
                        "createdDate": datetime.now(),
                        "editedDate": datetime.now(),
                    }
                    try:
                        self.__database.addDocument("fileResources", newDocument)
                    except Exception as e:
                        if isinstance(e, pymongo.errors.DuplicateKeyError):
                            if self.__debug:
                                print(
                                    "[backend.py-fileHandler-addDocument] Error: Duplicate key"
                                )
                        else:
                            if self.__debug:
                                print(
                                    f"[backend.py-fileHandler-addDocument] Error: {e}"
                                )
                        return "Failed"
                    return "Success"
                elif action == "remove":
                    try:
                        self.__database.deleteDocument(
                            "fileResources",
                            {
                                "fileName": data["fileName"],
                                "description": data["description"],
                                "base64value": data["base64value"],
                            },
                        )
                    except Exception as e:
                        if self.__debug:
                            print(f"[backend.py-fileHandler-deleteDocument] Error: {e}")
                        utils.log(
                            f"[backend.py-fileHandler-deleteDocument] Error: {e}",
                            "ERROR",
                        )
                        return "Failed"
                    return "Success"
                elif action == "update":
                    try:
                        self.__database.updateDocument(
                            "fileResources",
                            {
                                "fileName": data["fileName"],
                                "description": data["description"],
                                "base64value": data["base64value"],
                            },
                        )
                    except Exception as e:
                        if self.__debug:
                            print(f"[backend.py-fileHandler-updateDocument] Error: {e}")
                        utils.log(
                            f"[backend.py-fileHandler-updateDocument] Error: {e}",
                            "ERROR",
                        )
                        return "Failed"
                    return "Success"
            else:
                if self.__debug:
                    print("[backend.py-fileHandler-POST] Error: Invalid JSON object")
                utils.log(
                    "[backend.py-fileHandler-POST] Error: Invalid JSON object", "ERROR"
                )
                return "Failed"

    def getScanResult(self, method, data) -> str | list:
        """Get all the scan results from the database.

        :param method: GET
        :param data: JSON object
        """
        if method != "GET":
            if self.__debug:
                print(
                    f"[backend.py-getScanResult] Error: {method} is not a valid method"
                )
            utils.log(
                f"[backend.py-getScanResult] Error: {method} is not a valid method",
                "ERROR",
            )
            return "Failed"
        # Parse JSON object
        if method == "GET":
            if (
                "domain" in data.keys()
                and "scanDate" in data.keys()
                and len(data.keys()) == 2
            ):
                query = {}
                if data["domain"] != "":
                    query["domain"] = data["domain"]
                if data["scanDate"] != "":
                    dateParsed = datetime.strptime(
                        data["scanDate"], "%Y-%m-%dT%H:%M:%S.%fZ"
                    )
                    query["scanDate"] = dateParsed
                try:
                    cursor = self.__database.findDocument("scanResult", query)
                except Exception as e:
                    if self.__debug:
                        print(f"[backend.py-getScanResult] Error: {e}")
                    utils.log(f"[backend.py-getScanResult] Error: {e}", "ERROR")
                    return "Failed"
                listResult = []
                for item in cursor:
                    listResult.append(item)
                return str(listResult)
            else:
                utils.log(
                    "[backend.py-getScanResult] Error: Invalid JSON object", "ERROR"
                )
                if self.__debug:
                    print("[backend.py-getScanResult] Error: Invalid JSON object")
                return "Failed"
