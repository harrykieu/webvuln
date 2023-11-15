import source.core.backend

webvuln = source.core.backend.WebVuln()
with open('xss_payload.txt') as f:
    path_traversal_payloads = f.read().splitlines()

    for line in path_traversal_payloads:
        data = {
            "vulnType": "XSS",
            "resType": "payload",
            "value": line,
            "action": "add"
        }

        webvuln.resourceHandler("POST", data)
