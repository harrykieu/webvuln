from source.core.backend import WebVuln

a = WebVuln()
a.scanURL(['http://172.29.35.11/DVWA/vulnerabilities/fi/'], ['pathtraversal'])