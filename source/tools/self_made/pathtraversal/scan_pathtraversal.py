import requests
import re
import urllib.parse
import source.core.utils as utils

s = requests.Session()
s.headers[
    "User-Agent"
] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"


class PathTraversal:
    def __init__(self, url, resources):
        self.url = url
        self.resources = resources
        self.payloads = []
        self.result = False

    def checkPathTraversal(self):
        print("\n[+] Checking path traversal for", self.url)
        utils.log(
            f"[PathTraversal] Checking path traversal for {self.url}",
            "INFO",
            "pathTraversal.txt",
        )
        for payload in self.resources:
            encoded_payload = urllib.parse.quote(payload["value"])
            new_url = f"{self.url}?file_name={encoded_payload}"
            print("[!] Trying", new_url)
            utils.log(f"[PathTraversal] Trying {new_url}", "INFO", "pathTraversal.txt")
            res = s.get(new_url)
            if re.search(rb"root:x:0:0", res.content):
                print("[+] Path Traversal vulnerability detected, link:", new_url)
                utils.log(
                    f"[PathTraversal] Path Traversal vulnerability detected, link: {new_url}",
                    "INFO",
                    "pathTraversal.txt",
                )
                self.payloads.append(payload["value"])
                self.result = True
        print("[+] Check path traversal done")
        utils.log(
            "[PathTraversal] Check path traversal done", "INFO", "pathTraversal.txt"
        )
        return self.result, self.payloads
