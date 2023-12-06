from source.core.backend import WebVuln

a = WebVuln()
a.scanURL(['http://testphp.vulnweb.com/login.php'], ['idor'])