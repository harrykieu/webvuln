import requests
from bs4 import BeautifulSoup as bs
from urllib.parse import urlparse, urljoin
import sys
import re
import urllib.parse

s = requests.Session()
s.headers["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/117.0.5938.92"

class VulName:
  def __init__(self, url):
     self.url = url

  def scan_website(self, url):
    # Your code here

  def get_all_forms(self, url):
    # Your code here

  def get_form_details(self, form):
    # Your code here

  def check_VulName(self, url):
    # Your code here