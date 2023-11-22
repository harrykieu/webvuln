from source.core.backend import WebVuln

a = WebVuln()
a.scanURL(['http://berkeleyrecycling.org/page.php?id=1'], ['idor'])