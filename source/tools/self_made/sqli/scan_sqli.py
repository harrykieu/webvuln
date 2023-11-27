import requests
from bs4 import BeautifulSoup as bs
from urllib.parse import urlparse, urljoin
import urllib.parse
import source.core.utils as utils

# 06/09/2023 : Code check sqli thi duoc nhung chua goi la hoan hao, dang nghien cuu de cai tien
# maker : RBKING

s = requests.Session()
s.headers[
    "User-Agent"
] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"


class SQLi:
    def __init__(self, url, sqli_resources):
        self.url = url
        self.sqli_resources = sqli_resources
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

    forms = []

    def scan_website(self, url):
        global forms
        forms = bs(s.get(url).content, "html.parser").find_all("form")
        if self.check_sqli(url):
            return True
        return False

    # -----------------------------------------------------

    def is_vulnerable_sqli(self, response):
        errors = {
            "you have an error in your sql syntax;",
            "warning: mysql",
            "unclosed quotation mark after the character string",
            "quoted string not properly terminated",
        }

        response_time = response.elapsed.total_seconds()
        if response_time > 10:
            print("[!] Slow response time detected")
            return True

        complex_payload = "1' AND (SELECT * FROM information_schema.tables)='"
        if complex_payload in response.content.decode().lower():
            print("[!] Complex payload was successful")
            return True

        dump_payload = "1' UNION SELECT NULL, NULL, @@version;--"
        if dump_payload in response.content.decode().lower():
            print("[!] Data dump was successful")
            return True

        for error in errors:
            if error in response.content.decode().lower():
                return True

        return False

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

        for payload in self.sqli_resources:
            payload_str = payload["value"]
            encoded_payload = urllib.parse.quote(payload_str.encode('utf-8'))
            new_url = f"{self.url}?id={encoded_payload}"
            print("[!] Trying", new_url)

            res = s.get(new_url)
            if self.is_vulnerable_sqli(res):
                print("[+] SQL Injection vulnerability detected, link:", new_url)
                utils.log(
                            f"[SQLi] SQL Injection vulnerability detected, link: {new_url}",
                            "INFO",
                            "sqli_log.txt",
                        )
                self.payloads.append(payload["value"])
                self.result = True
                break

        forms = self.get_all_forms(self.url)
        print(f"[+] Detected {len(forms)} forms on {self.url} and form found: {forms}")

        for form in forms:
            form_details = self.get_form_details(form)
            for payload in self.sqli_resources:
                data = {}

                for input_tag in form_details["inputs"]:
                    if input_tag["value"] or input_tag["type"] == "hidden":
                        try:
                            data[input_tag["name"]] = input_tag["value"] + payload
                        except:
                            pass
                    elif input_tag["type"] != "submit":
                        data[input_tag["name"]] = f"test{payload}"

                self.url = urljoin(self.url, form_details["action"])
                if form_details["method"] == "post":
                    res = s.post(self.url, data=data)
                elif form_details["method"] == "get":
                    res = s.get(self.url, params=data)

                curr_url = self.url
                results = {"sqli": []}

                if self.is_vulnerable_sqli(res):
                    results["sqli"].append(
                        {"url": curr_url, "details": "[+] SQLi vulnerability detected"}
                    )

                    utils.log(
                            f"[SQL] SQL Injection detected in form, link: {self.url}",
                            "INFO",
                            "sqli_log.txt",
                        )
                    self.payloads.append(payload["value"])
                    self.result = True
                    break

        print("[+] Check SQLi done")
        utils.log(
            "[SQLi] Check SQLi done", "INFO", "sqli_log.txt"
        )
        return self.result, self.payloads
