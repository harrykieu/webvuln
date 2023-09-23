import re
import requests
from bs4 import BeautifulSoup

class FileUpload:
    def __init__(self, url):
        self.url = url
        self.session = None
        self.cookies = None

    def dvwa_login(self):
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
    
    def validURL(self):
        r = self.session.get(self.url)
        soup = BeautifulSoup(r.text, 'html.parser')
        form = soup.find_all("input", attrs={"type": "file"})
        if form:
            print("URL is valid for file upload")
            return True
        else:
            print("URL is not valid for file upload")
            return False

    def uploadfile(self):
        r = self.session.get(self.url)
        soup = BeautifulSoup(r.text, 'html.parser')
        # Finding user token to bypass CSRF
        usrtkSoup = soup.find_all('input',attrs={'name':'user_token'})
        if usrtkSoup:
            userToken = usrtkSoup[0]['value']
        
        # Finding the file upload form and extracting the necessary fields
        forms = soup.find_all('form', attrs={'enctype':'multipart/form-data'})
        dictInput = {}
        if forms:
            inputs = forms[0].find_all('input')
            if inputs:
                for i in inputs:
                    print(i)
                    """ if i["value"] == None:
                        dictInput[i["name"]] = ""
                    else:
                        dictInput[i["name"]] = i["value"] """
        print(dictInput)
        """ files = {
            "MAX_FILE_SIZE": (None, "100000"), # The maximum file size allowed by the server
            'uploaded': ('structure.png',open('source/tools/self_made/fileupload/structure.png', 'rb'), "image/png"),
            "Upload": (None, "Upload"), # Key for the file upload field,
            "user_token": (None, userToken)
        }
        session = requests.Session()
        p = session.post(self.url, files=files, cookies=self.cookies)
        soup = BeautifulSoup(p.text, 'html.parser')
        print(soup.find_all('pre')) """
    
    def main(self):
        self.dvwa_login()
        self.validURL()
        self.uploadfile()

a = FileUpload("http://localhost/dvwa/vulnerabilities/upload/")
a.main()