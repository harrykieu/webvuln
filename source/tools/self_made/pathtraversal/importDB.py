import source.core.backend

webvuln = source.core.backend.WebVuln()
with open(f'{__file__}\\..\\pathTraversalPayload.txt') as f:
    path_traversal_payloads = f.read().splitlines()

    for line in path_traversal_payloads:
        data = {
            "vulnType": "PathTraversal",
            "resType": "payload",
            "value": line,
            "action": "add"
        }

        webvuln.resourceHandler("POST", data)
