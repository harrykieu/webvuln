from source.core.backend import WebVuln
import json
import os

with open(f'{__file__}\\..\\path_traversal_payload.txt') as f:
    data = {"vulnType": "PathTraversal",
            "resType": "payload", "value": f.read().splitlines(), "action": "add"}

with open('data.json', 'w') as json_file:
    json.dump(data, json_file)

webvuln = WebVuln()
webvuln.resourceHandler("POST", data="data.json")

if os.path.exists(data.json):
    os.remove(data.json)
