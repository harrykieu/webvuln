from source.core.backend import WebVuln

a = WebVuln()
a.scanURL(['http://localhost:8091/loadImage.php'], ['pathtraversal'])