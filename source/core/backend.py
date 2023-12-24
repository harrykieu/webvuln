import json
import os
import platform
from datetime import datetime
from pathlib import Path

import pymongo
import requests

import source.core.utils as utils
from source.core.calSeverity import calculateWebsiteSafetyRate
from source.core.database.dbutils import DatabaseUtils
from source.tools.self_made.fileupload.scan_fileupload import FileUpload
from source.tools.self_made.idor.scan_idor import IDOR
from source.tools.self_made.lfi.scan_lfi import LFI
from source.tools.self_made.pathtraversal.scan_pathtraversal import PathTraversal
from source.tools.self_made.sqli.scan_sqli import SQLi
from source.tools.self_made.xss.scan_xss import XSS

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
        os.system("color")
        self.red = "\033[31m"  # Red color code for text output
        self.white = "\033[0m"  # White color code for text output
        self.green = "\033[32m"  # Green color code for text output
        self.blue = "\033[94m"  # Light blue color code for text output
        if platform.system() == "Windows":
            logFolder = "\\logs"
        else:
            logFolder = "/logs"
        if not os.path.exists(f"{ROOTPATH}{logFolder}"):
            os.mkdir(f"{ROOTPATH}{logFolder}")

    def setDebug(self, debug: bool) -> None:
        self.__debug = debug

    def getDebug(self) -> bool:
        return self.__debug

    def __sendResultFlask(self, data) -> str:
        """Send data to Flask.

        :param data: JSON object"""
        keys = json.loads(data).keys()
        if "result" in keys and len(keys) == 1:
            try:
                utils.log(f"/api/result: Sending data to Flask: {data}", "INFO")
                if self.__debug:
                    print(
                        f"{self.blue}/api/result: Sending data to Flask: {data}{self.white}"
                    )
                requests.post(
                    url="http://127.0.0.1:5000/api/result",
                    data=data,
                    headers={"Content-Type": "application/json", "Origin": "backend"},
                )
            except Exception as e:
                if self.__debug:
                    print(
                        f"{self.red}[backend.py-sendResultFlask] Error: {e}{self.white}"
                    )
                utils.log(f"[backend.py-sendResultFlask] Error: {e}", "ERROR")
                return "Failed"
            return "Success"

    def recvFlask(self, route, method, jsonData):
        """Receive data from Flask based on the route.

        :param route: The route of the request
        :param method: `GET` or `POST`
        :param jsonData: JSON object
        """
        if self.__debug:
            print(f"{self.blue}{method} {route}: {jsonData.keys()}{self.white}")
        if route == "/api/history":
            return self.__getScanResult(method, jsonData)
        elif route == "/api/resourcesnormal":
            return self.__resourceHandler(method, jsonData)
        elif route == "/api/resourcesfile":
            return self.__fileHandler(method, jsonData)
        elif route == "/api/scan":
            return self.__scanURL(jsonData["urls"], jsonData["modules"])
        else:
            utils.log(f"[backend.py-recvFlask] Error: Invalid route {route}", "ERROR")
            if self.__debug:
                print(
                    f"{self.red}[backend.py-recvFlask] Error: Invalid route {route}{self.white}"
                )
            raise ValueError(f"Invalid route {route}")

    def __scanURL(self, urls, modules):
        """Scan the URLs.

        :param urls: List of URLs
        :param modules: List of modules
        The return json will have the following format:
        ```
        {
            "result": [
                {
                    "domain": url,
                    "scanDate": datetime.now(),
                    "numVuln": "number of vulnerabilities",
                    "vulnerabilities": [
                        {
                            "type": "type of vulnerability",
                            "log": "scan log",
                            "payload": "payload",
                            "severity": "severity of the vulnerability"
                        }
                    ]
                }, ...
            ]
        }
        ```
        """
        # TODO: check for logs folder first
        # Remove all other log files
        for file in Path(f"{ROOTPATH}/logs").iterdir():
            if file.is_file() and file.name != "log.txt":
                os.remove(file)
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
            # For using ffuf or dirsearch (if needed)
            if "ffuf" in modules:
                modules.pop(modules.index("ffuf"))
                print("[-] Running ffuf...")
                commands.append(
                    f"{ROOTPATH}/source/tools/public/ffuf/ffuf.exe -u {url}/FUZZ -w {ROOTPATH}/source/tools/public/ffuf/fuzz-Bo0oM.txt -of json -o {filename} -p 0.2 -mc 200,301"
                )
            elif "dirsearch" in modules:
                modules.pop(modules.index("dirsearch"))
                print("[-] Running dirsearch...")
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
                    os.remove("result.txt")
            else:
                dirURL[f"{url}"] = [f"{url}"]
            print(f"[!] All URLs: {dirURL}")
        # Generate scan result
        for key in dirURL:
            resultURL = {
                "domain": key,
                "scanDate": datetime.now(),
                "numVuln": 0,
                "vulnerabilities": [],
            }
            # Call modules to scan
            for url in dirURL[key]:
                for module in modules:
                    if module == "lfi":
                        print("[+] Checking LFI vulnerability...")
                        lfi_resources = self.__resourceHandler(
                            "GET", {"vulnType": "lfi", "resType": "payload"}
                        )
                        if lfi_resources == "Failed":
                            utils.log(
                                "[backend.py-scanURL] Error: Failed to get resources",
                                "ERROR",
                            )
                            if self.__debug:
                                print(
                                    "[backend.py-scanURL] Error: Failed to get resources"
                                )
                            return "Failed"
                        LFIResult, LFIPayload = LFI(url, lfi_resources).check_lfi()
                        if LFIResult is True:
                            resultURL["numVuln"] += 1
                            resultURL["vulnerabilities"].append(
                                {
                                    "type": "LFI",
                                    "logs": open(
                                        f"{ROOTPATH}/logs/lfi_log.txt", "r"
                                    ).read(),
                                    "payload": LFIPayload,
                                    "severity": "High",
                                }
                            )
                    elif module == "sqli":
                        print("[+] Checking SQLi vulnerability...")
                        sqli_resources = self.__resourceHandler(
                            "GET", {"vulnType": "sqli", "resType": "payload"}
                        )
                        if sqli_resources == "Failed":
                            utils.log(
                                "[backend.py-scanURL] Error: Failed to get resources",
                                "ERROR",
                            )
                            if self.__debug:
                                print(
                                    "[backend.py-scanURL] Error: Failed to get resources"
                                )
                            return "Failed"
                        SQLiResult, SQLiPayload = SQLi(url, sqli_resources).check_sqli()

                        if SQLiResult is True:
                            resultURL["numVuln"] += 1
                            resultURL["vulnerabilities"].append(
                                {
                                    "type": "SQLi",
                                    "logs": open(
                                        f"{ROOTPATH}/logs/sqli_log.txt", "r"
                                    ).read(),
                                    "payload": SQLiPayload,
                                    "severity": "High",
                                }
                            )
                    elif module == "xss":
                        print("[+] Checking XSS vulnerability...")
                        xss_resources = self.__resourceHandler(
                            "GET", {"vulnType": "xss", "resType": "payload"}
                        )
                        if xss_resources == "Failed":
                            utils.log(
                                "[backend.py-scanURL] Error: Failed to get resources",
                                "ERROR",
                            )
                            if self.__debug:
                                print(
                                    "[backend.py-scanURL] Error: Failed to get resources"
                                )
                            return "Failed"
                        XSSResult, XSSPayload = XSS(url, xss_resources).check_xss()

                        if XSSResult is True:
                            resultURL["numVuln"] += 1
                            resultURL["vulnerabilities"].append(
                                {
                                    "type": "XSS",
                                    "logs": open(
                                        f"{ROOTPATH}/logs/xss_log.txt", "r"
                                    ).read(),
                                    "payload": XSSPayload,
                                    "severity": "Medium",
                                }
                            )
                    elif module == "fileupload":
                        print("[+] Checking file upload vulnerability...")
                        resources = self.__fileHandler("GET", {"description": ""})
                        if "dvwa" in url:
                            a = FileUpload(url, resources, isDVWA=True)
                        else:
                            a = FileUpload(url, resources)
                        FUResult, FUPayload = a.main()
                        if FUResult is True:
                            resultURL["numVuln"] += 1
                            resultURL["vulnerabilities"].append(
                                {
                                    "type": "File Upload",
                                    "logs": open(
                                        f"{ROOTPATH}/logs/fileupload.txt", "r"
                                    ).read(),
                                    "payload": FUPayload,
                                    "severity": "High",
                                }
                            )
                    elif module == "idor":
                        print("[+] Checking IDOR vulnerability...")
                        a = IDOR(url)
                        if a.check_idor() is True:
                            resultURL["numVuln"] += 1
                            resultURL["vulnerabilities"].append(
                                {
                                    "type": "IDOR",
                                    "description": f"{url} is vulnerable to IDOR",
                                    "severity": "Medium",
                                }
                            )
                    elif module == "pathtraversal":
                        print("[+] Checking path traversal vulnerability...")
                        pathTraversalParam = self.__resourceHandler(
                            "GET", {"vulnType": "pathTraversal", "resType": "parameter"}
                        )
                        resources = self.__resourceHandler(
                            "GET", {"vulnType": "pathTraversal", "resType": "payload"}
                        )
                        if resources == "Failed":
                            utils.log(
                                "[backend.py-scanURL] Error: Failed to get resources",
                                "ERROR",
                            )
                            if self.__debug:
                                print(
                                    "[backend.py-scanURL] Error: Failed to get resources"
                                )
                            return "Failed"
                        if pathTraversalParam == "Failed":
                            utils.log(
                                "[backend.py-scanURL] Error: Failed to get parameter",
                                "ERROR",
                            )
                            if self.__debug:
                                print(
                                    "[backend.py-scanURL] Error: Failed to get parameter"
                                )
                            return "Failed"
                        PTResult, PTPayload = PathTraversal(
                            url, resources, pathTraversalParam
                        ).checkPathTraversal()
                        if PTResult is True:
                            resultURL["numVuln"] += 1
                            resultURL["vulnerabilities"].append(
                                {
                                    "type": "Path Traversal",
                                    "logs": open(
                                        f"{ROOTPATH}/logs/pathTraversal.txt", "r"
                                    ).read(),
                                    "payload": PTPayload,
                                    "severity": "High",
                                }
                            )
                    else:
                        raise ValueError(f"Invalid module {module}")
            listResult.append(resultURL)
        for res in listResult:
            res["resultPoint"], res["resultSeverity"] = calculateWebsiteSafetyRate(
                res["vulnerabilities"]
            )
            try:
                self.__database.addDocument("scanResult", res)
            except Exception as e:
                if self.__debug:
                    print(f"[backend.py-scanURL] Error: {e}")
                utils.log(f"[backend.py-scanURL] Error: {e}", "ERROR")
                raise e
        result = {"result": listResult}
        try:
            self.__sendResultFlask(json.dumps(result, default=str))
        except Exception as e:
            if self.__debug:
                print(f"[backend.py-scanURL] Error: {e}")
            utils.log(f"[backend.py-scanURL] Error: {e}", "ERROR")
            raise e
        return json.dumps(result, default=str)

    def __resourceHandler(self, method, data) -> str | list:
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
            raise ValueError(f"{method} is not a valid method")
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
                    raise e
                listResult = []
                for item in cursor:
                    listResult.append(item)
                return json.dumps(listResult, default=str)
            else:
                utils.log("[backend.py-findDocument-GET] Error: Invalid JSON object")
                return "Failed"
        elif method == "POST":
            if (
                "vulnType" in data.keys()
                and "resType" in data.keys()
                and "value" in data.keys()
                and "action" in data.keys()
                and len(data.keys()) == 4
            ):
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
                        raise e
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
                    utils.log(
                        "[backend.py-resourceHandler-POST] Error: Invalid action",
                        "ERROR",
                    )
                    if self.__debug:
                        print("[backend.py-resourceHandler-POST] Error: Invalid action")
                    return "Failed"
            else:
                utils.log(
                    "[backend.py-resourceHandler-POST] Error: Invalid JSON object"
                )
                return "Failed"

    def __fileHandler(self, method, data) -> str | list:
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
                return json.dumps(listResult, default=str)
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

    def __getScanResult(self, method, data) -> str | list:
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
        else:
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
                return json.dumps(listResult, default=str)
            else:
                utils.log(
                    "[backend.py-getScanResult] Error: Invalid JSON object", "ERROR"
                )
                if self.__debug:
                    print("[backend.py-getScanResult] Error: Invalid JSON object")
                return "Failed"
