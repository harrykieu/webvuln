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

# a.scanURL(['http://localhost:12001'], ['fileupload'])
# a.scanURL(['http://localhost/formtest.html'], ['fileupload'])

# Push resource to db
""" with open(f'{ROOTPATH}/source/core/database/data_resources.json', 'r') as f:
    data = f.read()
f.close()
jsondata = loads(data)
jsondata[0]["action"] = "add"
print(jsondata)
print(a.resourceHandler('POST', data=jsondata[0]))"""
# Update resource in db
with open(f'{ROOTPATH}/source/core/database/data_resources.json', 'r') as f:
    data = f.read()
f.close
jsondata = loads(data)
jsondata[0]["action"] = "update"
jsondata[0]['value'] = ['Mozilla/6.0 ;--', 'Mozilla/6.1 ;--']
print(jsondata)
print(a.resourceHandler('POST', data=jsondata[0]))
# Upload file
""" obj = {}
obj['fileName'] = 'abc.png'
obj['description'] = 'valid'
with open(f'{ROOTPATH}/source/tools/self_made/fileupload/fileupload.png', 'rb') as f:
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
""" data = {'domain': 'All', 'scanDate': 'All'}
jsondata = dumps(data)
print(a.getScanResult('GET', data=jsondata)) """
