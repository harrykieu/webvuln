import json
import re
import urllib.parse

import requests

import source.core.utils as utils


class PathTraversal:
    def __init__(self, url, resources, parameterList):
        self.url = url
        self.resources = json.loads(resources)
        self.payloads = []
        self.result = False
        self.parameterList = json.loads(parameterList)

    def isParamRelevant(self, param):
        testUrl = f"{self.url}?{param}=test"
        defaultRes = requests.get(self.url)
        testRes = requests.get(testUrl)
        return defaultRes.content != testRes.content

    def checkPathTraversal(self):
        print("\n[+] Checking path traversal for", self.url)
        utils.log(
            f"[PathTraversal] Checking path traversal for {self.url}",
            "INFO",
            "pathTraversal.txt",
        )
        if not self.resources:
            print("\n[-] Resources not found!")
            utils.log(
                "[PathTraversal] Resources not found!",
                "ERROR",
                "pathTraversal.txt",
            )
            return self.result
               

        stopChecking = False
        if "?" in self.url:
            for payload in self.resources:
                encodedPayload = urllib.parse.quote(payload["value"])
                newUrl = re.sub(r'=.*?(&|$)', '=' + encodedPayload + '\\1', self.url)
                print("[!] Trying", newUrl)
                res = requests.get(newUrl)
                if re.search(rb"root:x:0:0", res.content):
                    print(
                        "[+] Path Traversal vulnerability detected, link:", newUrl
                    )
                    utils.log(
                        f"[PathTraversal] Path Traversal vulnerability detected, link: {newUrl}",
                            "INFO",
                            "pathTraversal.txt",
                        )
                    self.payloads.append(payload["value"])
                    self.result = True
                    stopChecking = True
                    break
        else:
            for paramInfo in self.parameterList:
                param = paramInfo["value"]

                if stopChecking is True:
                    break
                
                if not self.isParamRelevant(param):
                    print(f"[!] Skipping irrelevant parameter: {param}")
                    continue
                else:
                    for payload in self.resources:
                        encodedPayload = urllib.parse.quote(payload["value"])
                        newUrl = f"{self.url}?{param}={encodedPayload}"
                        print("[!] Trying", newUrl)
                        try:
                            res = requests.get(newUrl)
                            if re.search(rb"root:x:0:0", res.content):
                                print(
                                    "[+] Path Traversal vulnerability detected, link:", newUrl
                                )
                                utils.log(
                                    f"[PathTraversal] Path Traversal vulnerability detected, link: {newUrl}",
                                    "INFO",
                                    "pathTraversal.txt",
                                )
                                self.payloads.append(payload["value"])
                                self.result = True
                                stopChecking = True
                                break
                        except requests.exceptions.RequestException as e:
                            error_msg = f"Error connecting to {newUrl}: {e}"
                            print(error_msg)
                            utils.log(error_msg, "ERROR", "pathTraversal.txt")
                        
        print("[+] Check path traversal done")
        utils.log(
            "[PathTraversal] Check path traversal done", "INFO", "pathTraversal.txt"
        )
        return self.result, self.payloads
