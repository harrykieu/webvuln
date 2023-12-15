import base64
from json import dumps, loads
from source.core.backend import WebVuln
from pathlib import Path

ROOTPATH = Path(__file__).parent


a = WebVuln()
""" lista = a.resourceHandler(
    'GET', data={'vulnType': 'File Upload', 'resType': 'File'})
print(len(lista))
print(lista[0])
for a in lista:
    print(lista.index(a)) """
# NOTE: dvwa url must have / at the end
# print(a.scanURL(['http://localhost/dvwa/vulnerabilities/upload'], ['fileupload']))
#a.scanURL(["http://localhost:12001"], ["fileupload"])
# a.scanURL(["http://google.com/"], ["fileupload"])
""" scan_results = a.scanURL(
    ["http://localhost:8091/loadImage.php", "http://localhost:12001"],
    # ["http://localhost:8091/loadImage.php"],
    ["pathtraversal", "fileupload"],
)
print(scan_results) """
""" results = loads(scan_results)["result"]
a.generateJSONReport(results)
 """
# Push resource to db
""" with open(f'{ROOTPATH}/source/core/database/data_resources.json', 'r') as f:
    data = f.read()
f.close()
jsondata = loads(data)
jsondata[0]["action"] = "add"
print(jsondata)
print(a.resourceHandler('POST', data=jsondata[0]))"""
# Push normal resource to db
""" with open(
    f"{ROOTPATH}/source/tools/self_made/pathtraversal/pathTraversalPayload.txt", "r"
) as f:
    data = f.readlines()
f.close()
for line in data:
    jsondata = {
        "vulnType": "Path Traversal",
        "resType": "payload",
        "value": line.strip(),
        "action": "add",
    }
    a.resourceHandler("POST", data=jsondata)
# print(data) """
""" jsondata = loads(data)
jsondata[0]["action"] = "add"
print(jsondata)
print(a.resourceHandler('POST', data=jsondata[0]))
"""
# Update resource in db
""" with open(f'{ROOTPATH}/source/core/database/data_resources.json', 'r') as f:
    data = f.read()
f.close
jsondata = loads(data)
jsondata[0]["action"] = "update"
jsondata[0]['value'] = ['Mozilla/6.0 ;--', 'Mozilla/6.1 ;--']
print(jsondata)
print(a.resourceHandler('POST', data=jsondata[0])) """
# Upload file
""" obj = {}
obj['fileName'] = 'test.jpg'
obj['description'] = 'invalidbutvalidExtension'
with open(f'{ROOTPATH}/source/tools/self_made/fileupload/test.jpg', 'rb') as f:
    obj['base64value'] = base64.b64encode(f.read()).decode()
f.close()
obj['action'] = 'add'
print(a.fileHandler('POST', obj)) """
# Retrieve file
""" data = {'fileName': 'abc.png'}
jsondata = dumps(data)
print(jsondata) """
""" data = {'vulnType': 'File Upload', 'resType': 'File'}
jsonData = dumps(data)
resbig = a.resourceHandler('GET', jsonData)
for res in resbig:
    filecontentb64 = res['value']
# save file
with open(f'{ROOTPATH}/source/tools/self_made/fileupload/test2.jpg', 'wb') as f:
    f.write(base64.b64decode(filecontentb64))
 """
""" data = loads(
    open(f'{ROOTPATH}/source/core/database/data_scanResult.json', 'r').read())
for item in data:
    item['scanDate'] = datetime.strptime(
        item['scanDate'], "%Y-%m-%dT%H:%M:%S.%fZ")
    print(item)
    # a.saveScanResult(item) """
""" # Example: {'domain': 'example.com', 'scanDate': datetime.datetime(2023, 9, 23, 9, 31, 41, 274000), 'numVuln': 0, 'vulnerabilities': [], 'resultSeverity': 'None'}
dateFind = datetime.strptime(
    '2023-09-23T09:31:41.274Z', "%Y-%m-%dT%H:%M:%S.%fZ") """
# Get scan result
data = {"domain": "", "scanDate": ""}
jsondata = dumps(data)
b = loads(jsondata)
result = a.getScanResult("GET", b)
with open(f"{ROOTPATH}/data_scanResult.json", "w") as f:
    f.write(dumps(result, default=str))
