import source.core.backend

webvuln = source.core.backend.WebVuln()
with open('lfi_payload.txt') as f:
    path_traversal_payloads = f.read().splitlines()

    for line in path_traversal_payloads:
        data = {
            "vulnType": "LFI",
            "resType": "payload",
            "value": line,
            "action": "add"
        }

        webvuln.resourceHandler("POST", data)
