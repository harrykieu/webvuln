import urllib.parse
from urllib.parse import urljoin
import re
import requests
from bs4 import BeautifulSoup as bs

import source.core.utils as utils
import json

s = requests.Session()
s.headers[
    "User-Agent"
] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"


class SQLi:
    def __init__(self, url, sqli_resources):
        self.url = url
        self.sqli_resources = json.loads(sqli_resources)
        self.payloads = []
        self.result = False

    # Uncomment the code below for DWVA
    # login_payload = {
    #     "username": "admin",
    #     "password": "password",
    #     "Login": "Login",
    # }
    # # change URL to the login page of your DVWA login URL
    # login_url = "http://192.168.168.105/dvwa/login.php"

    # # login
    # r = s.get(login_url)
    # token = re.search("user_token'\s*value='(.*?)'", r.text).group(1)
    # login_payload['user_token'] = token
    # s.post(login_url, data=login_payload)

    # ---------------------------------------------------------------

    def is_vulnerable_sqli(self, original_response, modified_response):
        errors = {
            "you have an error in your sql syntax;",
            "warning: mysql",
            "unclosed quotation mark after the character string",
            "quoted string not properly terminated",
        }

        original_content = original_response.content.decode().lower()
        modified_content = modified_response.content.decode().lower()

        original_tables = set(re.findall(r'\bfrom\s+(\w+)', original_content))
        modified_tables = set(re.findall(r'\bfrom\s+(\w+)', modified_content))

        new_tables = modified_tables - original_tables
        if new_tables:
            print(f"[!] New tables detected: {new_tables}")
            return True

        for error in errors:
            if error in original_content:
                print(f"[!] SQL Injection error detected: {error}")
                return True
            elif error in modified_content:
                print(f"[!] SQL Injection error detected: {error}")
                return True
            
        return False

    # ---------------------------------
    def interact_with_form(self, form_url, form_details, payload):
        data = {}
        for input_tag in form_details["inputs"]:
            if input_tag["value"] or input_tag["type"] == "hidden":
                try:
                    data[input_tag["name"]] = input_tag["value"] + payload
                except:
                    pass
            elif input_tag["type"] != "submit":
                data[input_tag["name"]] = f"test{payload}"

        modified_response = s.post(form_url, data=data)

        return modified_response
    
    # ---------------------------------

    def get_all_forms(self, url):
        soup = bs(s.get(url).content, "html.parser")
        return soup.find_all("form")

    def get_form_details(self, form):
        details = {}
        try:
            action = form.attrs.get("action").lower()
        except:
            action = None

        method = form.attrs.get("method", "get").lower()

        inputs = []
        for input_tag in form.find_all("input"):
            input_type = input_tag.attrs.get("type", "text")
            input_name = input_tag.attrs.get("name")
            input_value = input_tag.attrs.get("value", "")
            inputs.append(
                {"type": input_type, "name": input_name, "value": input_value}
            )

        details["action"] = action
        details["method"] = method
        details["inputs"] = inputs
        return details

    # -------------------------------------------------------------

    def check_sqli(self):
        utils.log(
            f"[SQLi] Checking SQLi for {self.url}",
            "INFO",
            "sqli_log.txt",
        )

        print("\n[+] Checking SQLi")

        if not self.sqli_resources:
            print("\n[-] Resources not found!")
            utils.log(
                "[SQLi] Resources not found!",
                "ERROR",
                "sqli_log.txt",
            )
            return self.result

        original_response = s.get(self.url)

        for payload in self.sqli_resources:
            payload_str = payload["value"]
            encoded_payload = urllib.parse.quote(payload_str.encode("utf-8"))
            new_url = f"{self.url}?id={payload_str}"

            print("[!] Trying", new_url)

            modified_response = s.get(new_url)

            if self.is_vulnerable_sqli(original_response, modified_response):
                print("[+] SQL Injection vulnerability detected, link:", new_url)
                utils.log(
                    f"[SQLi] SQL Injection vulnerability detected, link: {new_url}, \nPayload: {payload_str}",
                    "INFO",
                    "sqli_log.txt",
                )
                self.payloads.append(payload["value"])
                self.result = True
                break

        results = {"sqli": []}
        forms = self.get_all_forms(self.url)
        print(f"[+] Detected {len(forms)} forms on {self.url} and form found: {forms}")

        for form in forms:
            form_details = self.get_form_details(form)
            for payload in self.sqli_resources:
                payload_str = payload["value"]
                encoded_payload = urllib.parse.quote(payload_str.encode("utf-8"))
                current_url = urljoin(self.url, form_details["action"])
                
                # Interact with the form using the payload
                modified_response = self.interact_with_form(current_url, form_details,  payload["value"])

                # Compare responses to check for SQL injection vulnerability
                if self.is_vulnerable_sqli(original_response, modified_response):
                    results["sqli"].append(
                        {"url": current_url, "details": "[+] SQLi vulnerability detected"}
                    )

                    utils.log(
                        f"[SQLi] SQL Injection detected in form with Payload: {payload_str}",
                        "INFO",
                        "sqli_log.txt",
                    )
                    self.payloads.append(payload["value"])
                    self.result = True
                    break

        print("[+] Check SQLi done")
        utils.log("[SQLi] Check SQLi done", "INFO", "sqli_log.txt")
        return self.result, self.payloads