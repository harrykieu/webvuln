import source.core.backend

webvuln = source.core.backend.WebVuln()
with open('sqli_payload.txt') as f:
    path_traversal_payloads = f.read().splitlines()

    for line in path_traversal_payloads:
        data = {
            "vulnType": "SQLI",
            "resType": "payload",
            "value": line,
            "action": "add"
        }

        webvuln.resourceHandler("POST", data)
