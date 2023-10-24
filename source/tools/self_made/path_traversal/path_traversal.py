import requests
from bs4 import BeautifulSoup as bs
from urllib.parse import urlparse, urljoin
import sys
import re 
import urllib.parse


s = requests.Session()
s.headers["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"

class PathTraversal:

  def __init__(self, url):
     self.url = url

  forms = []
  def scan_website(self):
    results = {
      "path_traversal": []
    }
    urls = urlparse(self.url)
    global forms
    forms = bs(s.get(self.url).content, "html.parser").find_all("form")

    if self.check_path_traversal():
      results["path_traversal"].append({
        "url": self.url,
        "details": "[+] path traversal detected"
      })

    return results

  def get_all_forms(self):
    soup = bs(s.get(self.url).content, "html.parser")
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
        inputs.append({"type": input_type, "name": input_name, "value": input_value})

    details["action"] = action
    details["method"] = method
    details["inputs"] = inputs
    return details

  def check_path_traversal(self):
    with open(f'{__file__}\\..\\path_traversal_payload.txt') as f:
      path_traversal_payloads = f.read().splitlines()
    
    print("\n[+] Checking path traversal")

    for payload in path_traversal_payloads:
      encoded_payload = urllib.parse.quote(payload)
      new_url = f"{self.url}?file_name={encoded_payload}"

      print("[!] Trying", new_url)
      res = s.get(new_url)

      if re.search(rb"root:x:0:0", res.content):
        print("[+] Path Traversal vulnerability detected, link:", new_url)
        return True
    print("[+] Check path traversal done")    

    return False

path_traversal = PathTraversal("http://localhost:8091/loadImage.php")
path_traversal.scan_website()