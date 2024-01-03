import json
import os
import re
from base64 import b64decode
import time

import requests
from bs4 import BeautifulSoup

import source.core.utils as utils


class FileUpload:
    def __init__(self, url, resources, isDVWA=False):
        self.url = url
        self.session = None
        self.cookies = None
        self.csrfExist = False
        self.isDVWA = isDVWA
        self.resources = json.loads(resources)
        self.isVuln = False
        self.filePayload = []
        # Color codes for text output
        os.system("color")
        self.red = "\033[31m"  # Red color code for text output
        self.white = "\033[0m"  # White color code for text output
        self.green = "\033[32m"  # Green color code for text output
        self.blue = "\033[94m"  # Light blue color code for text output

    def getCSRFToken(self, url) -> str:
        """Get CSRF token for the login page of the website."""
        r = self.session.get(url, cookies=self.cookies, allow_redirects=True)
        soup = BeautifulSoup(r.content, "html.parser")
        usrtkSoup = soup.find_all("input", attrs={"name": "user_token"})
        if usrtkSoup:
            self.csrfExist = True
            userToken = usrtkSoup[0]["value"]
            return userToken
        else:
            print(f"{self.red}[-] CSRF token not found!{self.white}")
            utils.log("[FileUpload] CSRF token not found!", "ERROR", "fileUpload.txt")
            return None

    def dvwaLogin(self) -> str:
        """(For DVWA only) Login to DVWA and return a session object."""
        if not self.isDVWA:
            return
        payload = {"username": "admin", "password": "password", "Login": "Login"}
        self.session = requests.Session()
        with self.session as c:  # TODO: get base url from provided url
            token = self.getCSRFToken("http://localhost/dvwa/login.php")
            payload["user_token"] = token
            c.post("http://localhost/dvwa/login.php", data=payload)
            self.cookies = c.cookies
            print(f"{self.green}[+] Logged in to DVWA!{self.white}")
            utils.log("[FileUpload] Logged in to DVWA!", "INFO", "fileUpload.txt")

    def dvwaChangeSecurity(self, level):
        """(For DVWA only) Change DVWA security level."""
        if not self.isDVWA:
            return
        userToken = self.getCSRFToken("http://localhost/dvwa/security.php")
        data = {"security": level, "seclev_submit": "Submit", "user_token": userToken}
        r = self.session.post(
            "http://localhost/dvwa/security.php", data=data, cookies=self.cookies
        )
        if r.status_code == 200:
            print(f"{self.green}[+] Security level changed to {level}!{self.white}")
            utils.log(
                "[FileUpload] Security level changed to " + level + "!",
                "INFO",
                "fileUpload.txt",
            )
        return r

    def getAllForms(self, url):
        r = self.session.get(url, cookies=self.cookies, allow_redirects=True)
        soup = BeautifulSoup(r.text, "html.parser")
        forms = soup.find_all("form", attrs={"enctype": "multipart/form-data"})
        if not forms:
            print(f"{self.red}[-] URL is not valid for file upload!{self.white}")
            utils.log(
                "[FileUpload] URL is not valid for file upload!",
                "ERROR",
                "fileUpload.txt",
            )
            return None
        print(f"{self.green}[+] URL is valid for file upload!{self.white}")
        utils.log(
            "[FileUpload] URL is valid for file upload!!",
            "INFO",
            "fileUpload.txt",
        )
        return forms

    def uploadFile(self) -> bool:
        """Upload file to the website."""
        forms = self.getAllForms(self.url)
        if not forms:
            print(f"{self.red}[-] URL is not valid for file upload!{self.white}")
            utils.log(
                "[FileUpload] URL is not valid for file upload!",
                "ERROR",
                "fileUpload.txt",
            )
            return self.isVuln
        for form in forms:
            self.sendPayload(self.getFormDetails(form))
        # Get return value and conclusion
        if self.isVuln:
            print(f"{self.green}[-] File upload vulnerability found!{self.white}")
            utils.log(
                "[FileUpload] File upload vulnerability found!",
                "INFO",
                "fileUpload.txt",
            )
        else:
            print(f"{self.red}[-] File upload vulnerability not found!{self.white}")
            utils.log(
                "[FileUpload] File upload vulnerability not found!",
                "INFO",
                "fileUpload.txt",
            )
        return self.isVuln

    def getFormDetails(self, form) -> dict:
        inputs = form.find_all("input")
        formDetails = {}
        if inputs:
            for i in inputs:
                if i["type"] == "file":
                    formDetails[i["name"]] = ""
                elif i["type"] == "submit":
                    if self.isDVWA:
                        formDetails[i["name"]] = "Upload"
                    pass
                else:
                    formDetails[i["name"]] = i["value"]
        return formDetails

    def sendPayload(self, formField) -> None:
        payload = {}
        # Add file
        validFiles = []
        validExtension = []
        validMH = []
        if not self.resources:
            print(f"{self.red}[-] Resources not found!{self.white}")
            utils.log(
                "[FileUpload] Resources not found!",
                "ERROR",
                "fileUpload.txt",
            )
            return self.isVuln
        for res in self.resources:
            if res["description"] == "valid":
                validFiles.append(res)
            elif res["description"] == "invalidbutvalidExtension":
                validExtension.append(res)
            elif res["description"] == "invalidbutvalidMH":
                validMH.append(res)
            else:
                pass
        print(f"{self.blue}[-] Uploading valid files...{self.white}")
        utils.log("[FileUpload] Uploading valid files...", "INFO", "fileUpload.txt")
        if len(validFiles) == 0 or len(validExtension) == 0 or len(validMH) == 0:
            print(f"{self.red}[-] Missing resources!{self.white}")
            utils.log(
                "[FileUpload] Missing resources!",
                "ERROR",
                "fileUpload.txt",
            )
            return self.isVuln
        for validFile in validFiles:
            for key in formField:
                if formField[key] != "":
                    payload.update({key: (None, formField[key])})
                else:
                    payload.update(
                        {
                            key: (
                                validFile["fileName"],
                                b64decode(validFile["base64value"]),
                                "image/jpeg",
                            )
                        }
                    )
            if self.csrfExist and self.isDVWA:
                payload.update({"user_token": self.getCSRFToken(self.url)})
            p = self.session.post(
                self.url, files=payload, cookies=self.cookies, allow_redirects=True
            )
            if p.history != []:
                if p.history[0].status_code == 301 or p.history[0].status_code == 302:
                    print(
                        f"{self.red}[!] File upload failed! Check the URL!{self.white}"
                    )
                    utils.log(
                        "[FileUpload] File upload failed! Check the URL!",
                        "ERROR",
                        "fileUpload.txt",
                    )
                    return self.isVuln
            if p.status_code != 200:
                print(f"{self.red}[!] Valid file upload failed!{self.white}")
                utils.log(
                    "[FileUpload] Valid file upload failed!", "ERROR", "fileUpload.txt"
                )
                self.isVuln = False
            elif self.checkSuccess(p.text) is False:
                print(f"{self.red}[!] Valid file upload failed!{self.white}")
                utils.log(
                    "[FileUpload] Valid file upload failed!", "ERROR", "fileUpload.txt"
                )
                self.isVuln = False
            else:
                print(f"{self.green}[!] Valid file upload success!{self.white}")
                utils.log(
                    "[FileUpload] Valid file upload success!",
                    "INFO",
                    "fileUpload.txt",
                )
                self.isVuln = True
        if self.isVuln is False:
            print(f"{self.red}[!] Valid file upload failed! Quitting...{self.white}")
            utils.log(
                "[FileUpload] Valid file upload failed! Quitting...",
                "ERROR",
                "fileUpload.txt",
            )
            return self.isVuln
        print(
            f"{self.blue}[-] Uploading invalid files with valid extension...{self.white}"
        )
        utils.log(
            "[FileUpload] Uploading invalid files with valid extension...",
            "INFO",
            "fileUpload.txt",
        )
        for validExtFile in validExtension:
            for key in formField:
                if formField[key] != "":
                    payload.update({key: (None, formField[key])})
                else:
                    payload.update(
                        {
                            key: (
                                validExtFile["fileName"],
                                b64decode(validExtFile["base64value"]),
                                "image/jpeg",
                            )
                        }
                    )
            if self.csrfExist and self.isDVWA:
                payload.update({"user_token": self.getCSRFToken(self.url)})
            print(payload)
            p = self.session.post(
                self.url, files=payload, cookies=self.cookies, allow_redirects=True
            )
            if p.status_code != 200:
                print(f"{self.red}[!] File upload failed!{self.white}")
                utils.log("[FileUpload] File upload failed!", "ERROR", "fileUpload.txt")
                self.isVuln = False
            elif self.checkSuccess(p.text) is False:
                print(f"{self.red}[!] File upload failed!{self.white}")
                utils.log("[FileUpload] File upload failed!", "ERROR", "fileUpload.txt")
                self.isVuln = False
            else:
                print(
                    f"{self.green}[!] Invalid file with valid extension upload success!{self.white}"
                )
                utils.log(
                    "[FileUpload] Invalid file with valid extension upload success!",
                    "INFO",
                    "fileUpload.txt",
                )
                self.filePayload.append(validExtFile["fileName"])
                self.isVuln = True
        if self.isVuln is False:
            print(
                f"{self.blue}[-] Uploading invalid files with valid magic number...{self.white}"
            )
            utils.log(
                "[FileUpload] Uploading invalid files with valid magic number...",
                "INFO",
                "fileUpload.txt",
            )
            for validMHFile in validMH:
                for key in formField:
                    if formField[key] != "":
                        payload.update({key: (None, formField[key])})
                    else:
                        payload.update(
                            {
                                key: (
                                    validMHFile["fileName"],
                                    b64decode(validMHFile["base64value"]),
                                    "image/jpeg",
                                )
                            }
                        )
                if self.csrfExist and self.isDVWA:
                    payload.update({"user_token": self.getCSRFToken(self.url)})
                p = self.session.post(self.url, files=payload, allow_redirects=True)
                if p.status_code != 200:
                    print(f"{self.red}[!] File upload failed!{self.white}")
                    utils.log(
                        "[FileUpload] File upload failed!",
                        "ERROR",
                        "fileUpload.txt",
                    )
                    self.isVuln = False
                elif self.checkSuccess(p.text) is False:
                    print(f"{self.red}[!] File upload failed!{self.white}")
                    utils.log(
                        "[FileUpload] File upload failed!",
                        "ERROR",
                        "fileUpload.txt",
                    )
                    self.isVuln = False
                else:
                    print(
                        f"{self.green}[!] Invalid file with valid magic number upload success!{self.white}"
                    )
                    utils.log(
                        "[FileUpload] Invalid file with valid magic number upload success!",
                        "INFO",
                        "fileUpload.txt",
                    )
                    self.filePayload.append(validMHFile["fileName"])
                    self.isVuln = True

    def checkSuccess(self, responseContent) -> bool:
        signatureList = ["uploaded", "successfully", "uploaded successfully"]
        soup = BeautifulSoup(responseContent, "html.parser")
        for s in signatureList:
            signature = soup.find_all(string=re.compile(s, re.IGNORECASE))
            if signature:
                for htmlSig in signature:
                    print(f"{self.green}[+] Signature found: '{htmlSig}'{self.white}")
                    utils.log(
                        "[FileUpload] Signature found: '" + htmlSig + "'",
                        "INFO",
                        "fileUpload.txt",
                    )
                return True
            else:
                print(f"{self.red}[+] Signature not found!{self.white}")
                utils.log(
                    "[FileUpload] Signature not found!",
                    "INFO",
                    "fileUpload.txt",
                )
                return False

    def main(self) -> bool:
        """Main function for file upload scanner."""
        print(f"{self.blue}[-] Checking the domain {self.url}...{self.white}")
        utils.log(
            "[FileUpload] Checking the domain " + self.url + "...",
            "INFO",
            "fileUpload.txt",
        )
        self.dvwaLogin()
        self.dvwaChangeSecurity("low")
        self.uploadFile()
        print(f"{self.blue}[-] File upload scan completed!{self.white}")
        utils.log(
            "[FileUpload] File upload scan completed!",
            "INFO",
            "fileUpload.txt",
        )
        utils.log(
            f"[FileUpload] Payloads used: {self.filePayload}",
            "INFO",
            "fileUpload.txt",
        )
        return self.isVuln, self.filePayload
