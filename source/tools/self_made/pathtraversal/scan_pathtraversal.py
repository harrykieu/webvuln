import requests
import re
import urllib.parse
import source.core.utils as utils

class PathTraversal:
    def __init__(self, url, resources, whitelist):
        self.url = url
        self.resources = resources
        self.payloads = []
        self.result = False
        self.whitelist = whitelist

    def is_param_relevant(self, param):
        test_url = f"{self.url}?{param}=test"
        default_res = requests.get(self.url)
        test_res = requests.get(test_url)
        return default_res.content != test_res.content

    def checkPathTraversal(self):
        print("\n[+] Checking path traversal for", self.url)
        utils.log(
            f"[PathTraversal] Checking path traversal for {self.url}",
            "INFO",
            "pathTraversal.txt",
        )

        stop_checking = False 

        for param_info in self.whitelist:
            param = param_info['value']

            if stop_checking is True:
                break  

            if not self.is_param_relevant(param):
                print(f"[!] Skipping irrelevant parameter: {param}")
                continue

            for payload in self.resources:
                encoded_payload = urllib.parse.quote(payload["value"])
                new_url = f"{self.url}?{param}={encoded_payload}"

                print("[!] Trying", new_url)
                utils.log(
                    f"[PathTraversal] Trying {new_url}", "INFO", "pathTraversal.txt")
                res = requests.get(new_url)
                if re.search(rb"root:x:0:0", res.content):
                    print("[+] Path Traversal vulnerability detected, link:", new_url)
                    utils.log(
                        f"[PathTraversal] Path Traversal vulnerability detected, link: {new_url}",
                        "INFO",
                        "pathTraversal.txt",
                    )
                    self.payloads.append(payload["value"])
                    self.result = True
                    stop_checking = True  
                    break  

        print("[+] Check path traversal done")
        utils.log(
            "[PathTraversal] Check path traversal done", "INFO", "pathTraversal.txt"
        )
        return self.result, self.payloads
