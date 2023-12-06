import requests
from bs4 import BeautifulSoup
import re
import source.core.utils as utils
from urllib.parse import urljoin
import json


class IDOR:
    def __init__(self, url, resources, idorParams):
        self.url = url
        self.session = requests.Session()
        self.session.headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"
        }
        self.resources = json.loads(resources)
        self.idorParams = json.loads(idorParams)
        self.result = False
        self.payloads = []
    
    def extract_urls(self):
        response = self.session.get(self.url)
        soup = BeautifulSoup(response.content, 'html.parser')
        urls = []
        for a_tag in soup.find_all('a', href=True):
            url = urljoin(self.url, a_tag['href'])
            urls.append(url)
        return urls
        
    # Code for compare two responses HTML
    def compare_responses(self, resp1, resp2):
    # Compare the content of 2 responses
    # If different => probably IDOR
        html1 = resp1.content
        html2 = resp2.content

        if html1 != html2:
            return True
        return False
    
    def check_unauthorized_access(self, response):
        # Check status code
        if response.status_code == 401 or response.status_code == 403:
            return True
        
        # Check HTML for error messages 
        errors = ["Access denied", "Unauthorized", "Permission denied"]

        for error in errors:
            if error in response.text:
                return True

        return False

    def check_idor(self, url):
        print("\n[+] Checking IDOR for", self.url)
        utils.log(
            f"[IDOR] Checking IDOR for {self.url}",
            "INFO", "idor.txt"
        )

        urls = self.extract_urls()
        for url in urls:
            for parameter in self.idorParams:
                for payload in self.resources:
                    
                    if re.search(rf"{parameter["value"]}=(\d+)", url):
                        originalId = re.search(rf"{parameter["value"]}=(\d+)", url).group(1)  
                        originalUrl = url 
                    
                        testUrl = re.sub(rf"{parameter["value"]}=\d+", f"{parameter["value"]}={payload["value"]}", url)
                        print("[+] Testing IDOR on URL:", testUrl)
                        testResp = self.session.get(testUrl)
                        originalResp = self.session.get(originalUrl)

                        if self.compare_responses(originalResp, testResp):
                            print("[!] IDOR detected on url:", testUrl)
                            utils.log(
                            f"[IDOR] IDOR vulnerability detected, link: {testUrl}",
                            "INFO",
                            "idor.txt",
                        )
                            self.result = True
                            self.payloads.append(payload["value"])
                            break
                        
                        if self.check_unauthorized_access(testResp):
                            print("[!] IDOR detected on url:", testUrl)
                            utils.log(
                                f"[IDOR] IDOR vulnerability detected, link: {testUrl}",
                                "INFO",
                                "idor.txt",
                            )
                            self.result = True
                            self.payloads.append(payload["value"])
                            break
                if self.result:
                    break
            if self.result:
                break
            
        print("[+] IDOR scan finished")                
        utils.log(
            "[IDOR] IDOR scan finished",
            "INFO",
            "idor.txt",
        )
        return self.result, self.payloads
        