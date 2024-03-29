import json
import requests
from bs4 import BeautifulSoup as bs
from urllib.parse import urljoin
import re
import urllib.parse
import source.core.utils as utils
import json


s = requests.Session()
s.headers[
    "User-Agent"
] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"


class LFI:
    def __init__(self, url, lfi_resources):
        self.url = url
        self.lfi_resources = json.loads(lfi_resources)
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
            # TODO: fix all bare except statements
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

    # --------------------------------------------------

    def check_lfi(self):
        # TODO: add payload to log, add log to utils
        utils.log(
            f"[LFI] Checking LFI for {self.url}",
            "INFO",
            "lfi_log.txt",
        )

        print("\n[+] Checking LFI")

        if not self.lfi_resources:
            print("\n[-] Resources not found!")
            utils.log(
                "[LFI] Resources not found!",
                "ERROR",
                "lfi_log.txt",
            )
            return self.result

        for payload in self.lfi_resources:
            payload_str = payload["value"]
            encoded_payload = urllib.parse.quote(payload_str.encode("utf-8"))
            new_url = re.sub(r'=.*?(&|$)', '=' + encoded_payload + '\\1', self.url)

            print("[!] Trying", new_url)
            res = s.get(new_url)

            if re.search(rb"root:x:0:0", res.content):
                print("[+] LFI vulnerability detected, link:", new_url)
                utils.log(
                    f"[LFI] Local File Injection vulnerability detected, link: {new_url}, \nPayload: {payload_str}",
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
                        f"[LFI] Local File Injection detected in form, with Payload: {payload}",
                        "INFO",
                        "lfi_log.txt",
                    )
                    self.payloads.append(payload["value"])
                    self.result = True
                    break

        print("[+] Check LFI done")
        utils.log("[LFI] Check LFI done", "INFO", "lfi_log.txt")

        return self.result, self.payloads
