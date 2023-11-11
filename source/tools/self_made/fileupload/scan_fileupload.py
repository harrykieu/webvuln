from base64 import b64decode
import re
import requests
from bs4 import BeautifulSoup
import source.core.utils as utils
import os


class FileUpload:
    def __init__(self, url, resources, isDVWA=False):
        self.url = url
        self.session = requests.Session()
        self.cookies = None
        self.csrfExist = False
        self.isDVWA = isDVWA
        self.resources = resources
        self.result = False
        os.system("color")
        self.red = "\033[31m"  # Red color code for text output
        self.white = "\033[0m"  # White color code for text output
        self.green = "\033[32m"  # Green color code for text output
        self.blue = "\033[94m"  # Light blue color code for text output

    def checkCSRF(self) -> str:
        """Check if CSRF is enabled on the website."""
        r = self.session.get(self.url)
        soup = BeautifulSoup(r.text, "html.parser")
        usrtkSoup = soup.find_all("input", attrs={"name": "user_token"})
        if usrtkSoup:
            self.csrfExist = True
            return "CSRF is enabled on the website"
        else:
            self.csrfExist = False
            return "CSRF is not enabled on the website"

    def getCSRFToken(self) -> str:
        """Get CSRF token for the login page of the website."""
        r = self.session.get(self.url, cookies=self.cookies)
        soup = BeautifulSoup(r.text, "html.parser")
        usrtkSoup = soup.find_all("input", attrs={"name": "user_token"})
        if usrtkSoup:
            self.csrfExist = True
            userToken = usrtkSoup[0]["value"]
            return userToken
        else:
            print(f"{self.red}[-] CSRF token not found!{self.white}")
            return None

    def dvwaLogin(self) -> str:
        """(For DVWA only) Login to DVWA and return a session object."""
        if not self.isDVWA:
            return
        payload = {"username": "admin", "password": "password", "Login": "Login"}
        with self.session as c:
            r = c.get("http://localhost/dvwa/login.php")
            token = re.search("user_token'\s*value='(.*?)'", r.text).group(1)
            payload["user_token"] = token
            c.post("http://localhost/dvwa/login.php", data=payload)
            self.cookies = c.cookies

    def dvwaChangeSecurity(self, level):
        """(For DVWA only) Change DVWA security level."""
        if not self.isDVWA:
            return
        userToken = self.getCSRFToken()
        data = {"security": level, "seclev_submit": "Submit", "user_token": userToken}
        r = self.session.post("http://localhost/dvwa/security.php", data=data)
        print("Security level changed to " + level)
        return r

    def getAllForms(self, url):
        r = self.session.get(url, cookies=self.cookies)
        soup = BeautifulSoup(r.text, "html.parser")
        forms = soup.find_all("form", attrs={"enctype": "multipart/form-data"})
        if not forms:
            print("URL is not valid for file upload")
            return None
        print("URL is valid for file upload")
        return forms

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

    def uploadFile(self) -> bool:
        """Upload file to the website."""
        forms = self.getAllForms(self.url)
        if not forms:
            utils.log("[FileUpload] URL is not valid for file upload", "ERROR")
            return self.result
        for form in forms:
            self.craftPayload(self.getFormDetails(form))
        return self.result

    def craftPayload(self, formField) -> None:
        payload = {}
        # Add file
        validFiles = []
        validExtension = []
        validMH = []
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
                payload.update({"user_token": self.getCSRFToken()})
            p = self.session.post(self.url, files=payload, cookies=self.cookies)
            if p.history != []:
                if p.history[0].status_code == 301 or p.history[0].status_code == 302:
                    print(
                        f"{self.red}[!] File upload failed! Check the URL!{self.white}"
                    )
                    return self.result
            if p.status_code != 200:
                print(f"{self.red}[!] File upload failed!{self.white}")
                self.result = False
            elif self.checkSuccess(p.text) is False:
                print(f"{self.red}[!] File upload failed!{self.white}")
                self.result = False
            else:
                print(f"{self.green}[!] Valid file upload success!{self.white}")
                self.result = True
        if self.result is False:
            print(f"{self.red} [!] Valid file upload failed! Quitting...{self.white}")
            return self.result
        print(
            f"{self.blue}[-] Uploading invalid files with valid extension...{self.white}"
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
                payload.update({"user_token": self.getCSRFToken()})
            p = self.session.post(self.url, files=payload, cookies=self.cookies)
            if p.status_code != 200:
                print(f"{self.red}[!] File upload failed!{self.white}")
                self.result = False
            elif self.checkSuccess(p.text) is False:
                print(f"{self.red}[!] File upload failed!{self.white}")
                self.result = False
            else:
                print(
                    f"{self.green}[!] Invalid file with valid extension upload success!{self.white}"
                )
                self.result = True
        if self.result is False:
            print(
                f"{self.blue}[-] Uploading invalid files with valid magic number...{self.white}"
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
                    payload.update({"user_token": self.getCSRFToken()})
                p = self.session.post(
                    self.url,
                    files=payload,
                )
                if p.status_code != 200:
                    print(f"{self.red}[!] File upload failed!{self.white}")
                    self.result = False
                elif self.checkSuccess(p.text) is False:
                    print(f"{self.red}[!] File upload failed!{self.white}")
                    self.result = False
                else:
                    print(
                        f"{self.green}[!] Invalid file with valid magic number upload success!{self.white}"
                    )
                    self.result = True

    def checkSuccess(self, responseContent) -> bool:
        signatureList = ["uploaded", "successfully", "uploaded successfully"]
        soup = BeautifulSoup(responseContent, "html.parser")
        for s in signatureList:
            signature = soup.find_all(string=re.compile(s, re.IGNORECASE))
            if signature:
                for htmlSig in signature:
                    print(f"{self.green}[+] Signature found: {htmlSig}{self.white}")
                print(f"{self.green}[+] File upload success!{self.white}")
                return True
            else:
                print(f"{self.red}[+] Signature not found!{self.white}")
                return False

    def main(self) -> bool:
        self.dvwaLogin()
        self.dvwaChangeSecurity("low")
        self.uploadFile()
        return self.result
