from pymongo import MongoClient 
from bson.objectid import ObjectId
from collections import OrderedDict
import json
import  utils 
import os
from isodate import parse_datetime 
client = MongoClient(os.getenv("DATABASE_URI"))
db = client.webvuln


db.scanResult.drop()
db.create_collection("scanResult")
database_utils_scan = utils.Database_utils_scan()
scanResult = db["scanResult"]


with open(f'{__file__}\\..\\scanResult.json','r') as j:
    vexpr = {"$jsonSchema":json.load(j)}

# assign the schema validation expression to the cmd variable
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
        file_data = json.load(file)

database_utils_scan.add_document("scanResult",file_data)


# document = database_utils.find_document("scanResult", {})
# print(list(document))


# database_utils.delete_document("domain", {"domain":"example.com"})


# database_utils.edit_document("scanResult", {"domain":"example2.com"},{"$set":{"domain":"example4.com"}})

############################################################################################################

db.resources.drop()
db.create_collection("resources")
database_utils_resources = utils.Database_utils_resources()
resources = db["resources"]

with open(f'{__file__}\\..\\resources.json','r') as j:
    vexpr = {"$jsonSchema":json.load(j)}

# assign the schema validation expression to the cmd variable
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
        file_data_1 = json.load(file)
database_utils_resources.add_document("resources",file_data_1)    
    
# Disconnect from the database    
database_utils_resources.disconnect()