import requests
from bs4 import BeautifulSoup as bs
from urllib.parse import urljoin
import re
import urllib.parse
import source.core.utils as utils

# 06/09/2023 : CODE Can cai thien them mot so phuong dien de chen tim ra dia file (can cai tien tu dong 110 tro di)
# maker : RBKING

s = requests.Session()
s.headers[
    "User-Agent"
] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"


class LFI:
    def __init__(self, url, lfi_resources):
        self.url = url
        self.lfi_resources = lfi_resources
        self.payloads = []
        self.result = False

    forms = []

    def scan_website(self, url):
        global forms
        forms = bs(s.get(url).content, "html.parser").find_all("form")

        if self.check_lfi(url):
            return True
        return False

    # ------------------------------------------------

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
        return 0

    # --------------------------------------------------

    def check_lfi(self):

        utils.log(
            f"[LFI] Checking LFI for {self.url}",
            "INFO",
            "lfi_log.txt",
        )

        print("\n[+] Checking LFI")

        for payload in self.lfi_resources:
            encoded_payload = urllib.parse.quote(payload)
            new_url = f"{self.url}?page={encoded_payload}"

            print("[!] Trying", new_url)
            res = s.get(new_url)

            if re.search(rb"root:x:0:0", res.content):
                print("[+] LFI vulnerability detected, link:", new_url)
                utils.log(
                            f"[LFI] Local File Injection vulnerability detected, link: {new_url}",
                            "INFO",
                            "lfi_log.txt",
                        )
                self.payloads.append(payload["value"])
                self.result = True
                break

        forms = self.get_all_forms(self.url)
        print(f"[+] Detected {len(forms)} forms on {self.url}.")

        # -------------

        for form in forms:
            form_details = self.get_form_details(form)
            print("\n[+] Checking path LFI")

            for payload in self.lfi_resources:
                data = {}

                for input_tag in form_details["inputs"]:
                    if input_tag["value"] or input_tag["type"] == "hidden":
                        try:
                            data[input_tag["name"]] = input_tag["value"] + payload
                        except:
                            pass
                    elif input_tag["type"] != "submit":
                        data[input_tag["name"]] = payload

                self.url = urljoin(self.url, form_details["action"])
                if form_details["method"] == "post":
                    res = s.post(self.url, data=data)
                elif form_details["method"] == "get":
                    res = s.get(self.url, params=data)

                if re.search(rb"root:x:0:0", res.content):
                    print("[+] Local File Injection detected, link:", self.url)
                    utils.log(
                            f"[LFI] Local File Injection detected in form, link: {self.url}",
                            "INFO",
                            "lfi_log.txt",
                        )
                    self.payloads.append(payload["value"])
                    self.result = True
                    break
                    

        print("[+] Check LFI done")
        utils.log(
            "[LFI] Check LFI done", "INFO", "lfi_log.txt"
        )

        return self.result, self.payloads
