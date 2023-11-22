import source.core.backend 

webvuln = source.core.backend.WebVuln()
with open(f'{__file__}\\..\\IdorPayload.txt') as f:
    idor_payload = f.read().splitlines()

    for line in idor_payload:
        data = {
            "vulnType": "idor",
            "resType": "payload",
            "value": line,
            "action": "add"
        }

        webvuln.resourceHandler("POST", data)