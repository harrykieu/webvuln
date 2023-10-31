import requests
import re
import urllib.parse
import pymongo
import os

s = requests.Session()
s.headers["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"


class PathTraversal:
    def __init__(self, url):
        self.url = url
        self.client = pymongo.MongoClient(os.getenv("DATABASE_URI"))
        self.db = self.client["webvuln"]

    def scanWebsite(self):
        results = {
            "path_traversal": []
        }

        if self.checkPathTraversal():
            results["path_traversal"].append({
                "url": self.url,
                "details": "[+] path traversal detected"
            })

        return results

    def checkPathTraversal(self):
        # Fetch path traversal payloads from the database
        collection = self.db["resources"]
        path_traversal_payloads = [
            doc["value"] for doc in collection.find({"vulnType": "PathTraversal"})]

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

    def close(self):
        self.client.close()



