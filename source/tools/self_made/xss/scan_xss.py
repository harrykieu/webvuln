import requests
from bs4 import BeautifulSoup as bs
from urllib.parse import urlparse, urljoin
import urllib.parse
import source.core.utils as utils

# 06/09/2023 : CODE Can cai thien them tinh nang check submit selection
# maker : RBKING

s = requests.Session()
s.headers["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"


class XSS:

    def __init__(self, url, xss_resources):
        self.url = url
        self.xss_resources = xss_resources
        self.payloads = []
        self.result = False

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
        soup = bs(s.get(url).content, "html.parser")
        global forms
        forms = bs(s.get(url).content, "html.parser").find_all("form")

        # Scan XSS
        if self.check_xss(url):
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
                {"type": input_type, "name": input_name, "value": input_value})

        details["action"] = action
        details["method"] = method
        details["inputs"] = inputs
        return details

    # ---------------------------------------------------------------------

    def check_xss(self):
        utils.log(
            f"[XSS] Checking XSS for {self.url}",
            "INFO",
            "xss_log.txt",
        )

        print("\n[+] Checking XSS")

        if not self.xss_resources:
            print(f"\n[-] Resources not found!")
            utils.log(
                "[XSS] Resources not found!",
                "ERROR",
                "xss_log.txt",
            )
            return self.result
            sys.exit(1)

        for payload in self.xss_resources:
            payload_str = payload["value"]
            encoded_payload = urllib.parse.quote(payload_str.encode('utf-8'))
            new_url = f"{self.url}?q={encoded_payload}"

            print("[!] Trying", new_url)
            res = s.get(new_url)

            if payload["value"] in res.text:
                print("[+] XSS vulnerability detected, link:", new_url)
                utils.log(
                    f"[XSS] XSS vulnerability detected, link: {new_url}",
                    "INFO",
                    "xss_log.txt",
                )
                self.payloads.append(payload["value"])
                self.result = True
                break

        forms = self.get_all_forms(self.url)
        print(
            f"[+] Detected {len(forms)} forms on {self.url}, form found: {forms}\n")

        for form in forms:
            form_details = self.get_form_details(form)

            for payload in self.xss_resources:
                data = {}

                for input_tag in form_details["inputs"]:
                    if input_tag["value"] or input_tag["type"] == "hidden":
                        try:
                            data[input_tag["name"]] = input_tag["value"] + payload["value"]
                        except:
                            pass
                    elif input_tag["type"] != "submit":
                        data[input_tag["name"]] = payload["value"]

                form_action_url = urljoin(self.url, form_details["action"])
                if form_details["method"] == "post":
                    res = s.post(form_action_url, data=data)
                elif form_details["method"] == "get":
                    res = s.get(form_action_url, params=data)

                if payload["value"] in res.text:
                    print("[+] XSS vulnerability detected in form, link:", form_action_url)
                    utils.log(
                        f"[XSS] XSS detected in form, link: {form_action_url}",
                        "INFO",
                        "xss_log.txt",
                    )
                    self.payloads.append(payload["value"])
                    self.result = True
                    break

        print("[+] Check XSS done")
        utils.log(
            "[XSS] Check XSS done", "INFO", "xss_log.txt"
        )

        return self.result, self.payloads
