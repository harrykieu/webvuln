import re
import requests
from bs4 import BeautifulSoup


class FileUpload:
    def __init__(self, url, resources, isDVWA=False):
        self.url = url
        self.session = requests.Session()
        self.cookies = None
        self.csrfExist = False
        self.isDVWA = isDVWA
        self.resources = resources

    def checkCSRF(self) -> str:
        """Check if CSRF is enabled on the website.
        """
        r = self.session.get(self.url)
        soup = BeautifulSoup(r.text, 'html.parser')
        usrtkSoup = soup.find_all('input', attrs={'name': 'user_token'})
        if usrtkSoup:
            self.csrfExist = True
            return "CSRF is enabled on the website"
        else:
            self.csrfExist = False
            return "CSRF is not enabled on the website"

    def getCSRFToken(self) -> str:
        """Get CSRF token for the login page of the website.
        """
        r = self.session.get(self.url)
        soup = BeautifulSoup(r.text, 'html.parser')
        usrtkSoup = soup.find_all('input', attrs={'name': 'user_token'})
        if usrtkSoup:
            userToken = usrtkSoup[0]['value']
            return userToken
        else:
            print("No CSRF token found!")
            return None

    def dvwaLogin(self) -> str:
        """(For DVWA only) Login to DVWA and return a session object.
        """
        if not self.isDVWA:
            return
        payload = {
            'username': 'admin',
            'password': 'password',
            'Login': 'Login'
        }
        with self.session as c:
            r = c.get('http://localhost/dvwa/login.php')
            token = re.search("user_token'\s*value='(.*?)'", r.text).group(1)
            payload['user_token'] = token
            c.post('http://localhost/dvwa/login.php', data=payload)
            self.cookies = c.cookies

    def dvwaChangeSecurity(self, level):
        """(For DVWA only) Change DVWA security level.
        """
        if not self.isDVWA:
            return
        userToken = self.getCSRFToken()
        data = {
            'security': level,
            'seclev_submit': 'Submit',
            'user_token': userToken
        }
        r = self.session.post('http://localhost/dvwa/security.php', data=data)
        print("Security level changed to " + level)
        return r

    def get_all_forms(self, url):
        r = self.session.get(url)
        soup = BeautifulSoup(r.text, 'html.parser')
        forms = soup.find_all('form', attrs={'enctype': 'multipart/form-data'})
        if not forms:
            print("URL is not valid for file upload")
            return None
        print("URL is valid for file upload")
        return forms

    def get_form_details(self, form) -> dict:
        inputs = form.find_all('input')
        formDetails = {}
        if inputs:
            for i in inputs:
                if i["type"] == "file":
                    formDetails[i["name"]] = ""
                elif i["type"] == "submit":
                    pass
                else:
                    formDetails[i["name"]] = i["value"]
        return formDetails

    def uploadFile(self):
        """Upload file to the website.
        """
        forms = self.get_all_forms(self.url)
        for form in forms:
            self.craftPayload(self.get_form_details(form))

        # Uploading valid file first for testing """
        """  # Crafting the payload
        
        session = requests.Session()
        p = session.post(self.url, files=payload, cookies=self.cookies)
        if p.status_code != 200:
            print("File upload failed")
            return    
        soup = BeautifulSoup(p.text, 'html.parser')
        # The signature of a successful file upload
        signatureList = ["uploaded", "successfully", "uploaded successfully"]
        for s in signatureList:
            signature = soup.find_all(string=re.compile(s, re.IGNORECASE))
            if signature:
                for htmlSig in signature:
                    print(htmlSig)
                print("File uploaded successfully")
                return """

    def craftPayload(self, formField):
        payload = {}
        # Add file
        for res in self.resources:
            for key in formField:
                if formField[key] != "":
                    payload.update({key: (None, formField[key])})
                else:
                    payload.update(
                        {key: ('abc.jpg', res['value'], "image/jpeg")})
            p = self.session.post(self.url, files=payload)
            if p.status_code != 200:
                print("File upload failed")
                return
            soup = BeautifulSoup(p.text, 'html.parser')
            # The signature of a successful file upload
            signatureList = ["uploaded",
                             "successfully", "uploaded successfully"]
            for s in signatureList:
                signature = soup.find_all(string=re.compile(s, re.IGNORECASE))
                if signature:
                    for htmlSig in signature:
                        print(htmlSig)
                    print("File uploaded successfully")
                    break

    def main(self):
        self.dvwaLogin()
        self.dvwaChangeSecurity("low")
        self.uploadFile()
