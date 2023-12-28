from source.core.backend import WebVuln

a = WebVuln()
a._WebVuln__scanURL(['http://testphp.vulnweb.com/artists.php'], ['idor'])