import requests
from bs4 import BeautifulSoup
import re
import source.core.utils as utils
from urllib.parse import urljoin


class IDOR:
    def __init__(self, url, resources, idor_params):
        self.url = url
        self.session = requests.Session()
        self.session.headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"
        }
        self.resources = resources
        self.idor_params = idor_params

    def scan_website(self, url):
        results = {
            "idor": [] 
        }

        if self.check_idor(url):
            results["idor"].append({
                "url": url,
                "details": "[+] IDOR detected"
            })
            return True
        return False
    
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
            for param in self.idor_params:
                for payload in self.resources:
                    if re.search(rf"{param}=(\d+)", url):
                        original_id = re.search(rf"{param}=(\d+)", url).group(1)  
                        original_url = url 
                    
                        test_url = re.sub(rf"{param}=\d+", f"{param}={payload}", url)
                        test_resp = self.session.get(test_url)
                        original_resp = self.session.get(original_url)

                        if self.compare_responses(original_resp, test_resp):
                            print("[!] IDOR detected on url:", test_url)
                            return True
                        utils.log(
                            f"[IDOR] IDOR vulnerability detected, link: {test_url}",
                            "INFO",
                            "idor.txt",
                        )
                        
                        if self.check_unauthorized_access(test_resp):
                            print("[!] IDOR detected on url:", test_url)
                            return True
                        utils.log(
                            f"[IDOR] IDOR vulnerability detected, link: {test_url}",
                            "INFO",
                            "idor.txt",
                        )

        return False
        