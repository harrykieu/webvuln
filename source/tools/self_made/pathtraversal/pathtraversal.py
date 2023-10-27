import requests
import re
import urllib.parse


s = requests.Session()
s.headers["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"


class PathTraversal:

    def __init__(self, url):
        self.url = url

    def scanWebsite(self):
        results = {
            "path_traversal": []
        }

        if self.checkPathTraversal():
            results["path_traversal"].append({
                "url": self.url,
                "details": "[+] path traversal detected"
            })
        else:
            results["path_traversal"].append({
                "url": self.url,
                "details": "[-] path traversal not detected"
            })

        return results

    def checkPathTraversal(self):
        with open(f'{__file__}\\..\\pathTraversalPayload.txt') as f:
            path_traversal_payloads = f.read().splitlines()

        print("\n[+] Checking path traversal")

        for payload in path_traversal_payloads:
            encoded_payload = urllib.parse.quote(payload)
            new_url = f"{self.url}?file_name={encoded_payload}"

            print("[!] Trying", new_url)
            res = s.get(new_url)

            if re.search(rb"root:x:0:0", res.content):
                print("[+] Path Traversal vulnerability detected, link:", new_url)
                return True

        print("[+] Check path traversal done")

        return False


