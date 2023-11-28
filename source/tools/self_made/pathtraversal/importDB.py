import source.core.backend 

webvuln = source.core.backend.WebVuln()
with open(f'{__file__}\\..\\pathTraversalParameter.txt') as f:
    path_traversal_parameter = f.read().splitlines()

    for line in path_traversal_parameter:
        data = {
            "vulnType": "pathTraversal",
            "resType": "parameter",
            "value": line,
            "action": "add"
        }

        webvuln.resourceHandler("POST", data)