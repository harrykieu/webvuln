import re
import requests
from bs4 import BeautifulSoup

class FileUpload:
    def __init__(self, url):
        self.url = url

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
            p = c.post('http://localhost/dvwa/login.php', data=payload)
        return c
    
    def validURL(self):
        c = self.dvwa_login()
        r = c.get(self.url)
        soup = BeautifulSoup(r.text, 'html.parser')
        input = soup.find_all('input', type='file')
        if input:
            print("URL is valid for file upload")
            return True
        else:
            print("URL is not valid for file upload")
            return False

    def uploadfile(self):
        if self.validURL() == False:
            return
        c = self.dvwa_login()
        p = c.post(self.url, files={'uploaded': open('source/tools/self_made/fileupload/structure.png', 'rb')})
        soup = BeautifulSoup(p.text, 'html.parser')
        print(soup.find_all('pre'))
    


a = FileUpload("http://localhost/dvwa/vulnerabilities/upload/")
a.validURL()
a.uploadfile()