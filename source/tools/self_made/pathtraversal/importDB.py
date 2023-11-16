import source.core.backend

webvuln = source.core.backend.WebVuln()
with open(f'{__file__}\\..\\white_list.txt') as f:
    path_traversal_payloads = f.read().splitlines()

    for line in path_traversal_payloads:
        data = {
            "vulnType": "pathTraversal",
            "resType": "whitelist",
            "value": line,
            "action": "add"
        }

        webvuln.resourceHandler("POST", data)
