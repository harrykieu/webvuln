from pymongo import MongoClient 
from collections import OrderedDict
import json
import  utils 
import os
from isodate import parse_datetime 


client = MongoClient(os.getenv("DATABASE_URI"))
db = client.webvuln
database_utils = utils.DatabaseUtils()


db.scanResult.drop()
db.create_collection("scanResult")
scanResult = db["scanResult"]
current_dir = os.path.dirname(os.path.abspath(__file__))



json_path_1 = os.path.join(current_dir, '..','schema', 'scanResult.json')
with open(json_path_1, 'r') as j:
    vexpr = {"$jsonSchema": json.load(j)}
    

cmd = OrderedDict([
    ("collMod","scanResult"),
    ("validator", vexpr),
    ("validationLevel","moderate")
])


try:
    db.command(cmd)
    print("Check whether valdiation works for scanResult: All good")
except Exception as e:
    print("exc",e)


with open(f'{__file__}\\..\\data_scanResult.json') as file:
        scanResult_data = json.load(file)
        
for document in scanResult_data:
    document["scanDate"] = parse_datetime(document["scanDate"])
database_utils.addDocument("scanResult",scanResult_data)


# document = database_utils.findDocument("scanResult", {})
# print(list(document))


# database_utils.deleteDocument("scanResult", {"domain":"example.com"})


# database_utils.editDocument("scanResult", {"domain":"example2.com"},{"$set":{"domain":"example4.com"}})
   

db.resources.drop()
db.create_collection("resources")
resources = db["resources"]

json_path_2 = os.path.join(current_dir, '..','schema', 'resources.json')
with open(json_path_2,'r') as j:
    vexpr = {"$jsonSchema":json.load(j)}


cmd = OrderedDict([
    ("collMod", "resources"),
    ("validator", vexpr),
    ("validationLevel", "moderate")
])


try:
    db.command(cmd)
    print("\nCheck whether validation works for resources: All good")
except Exception as e:
    print("exc", e)


with open(f'{__file__}\\..\\data_resources.json') as file:
        resources_data = json.load(file)
        
for document in resources_data:
    document["createdDate"] = parse_datetime(document["createdDate"])
    document["editedDate"] = parse_datetime(document["editedDate"])
database_utils.addDocument("resources",resources_data)    

 
database_utils.disconnect()