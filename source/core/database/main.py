from pymongo import MongoClient 
from bson.objectid import ObjectId
from collections import OrderedDict
import sys
import json
import  utils 
import os

client = MongoClient(os.getenv("DATABASE_URI"))


db = client.webvuln
db.scanResult.drop()
db.create_collection("scanResult")
database_utils = utils.DatabaseUtils()
scanResult = db["scanResult"]


with open(f'{__file__}\\..\\scanResult.json','r') as j:
    vexpr = {"$jsonSchema":json.load(j)}

# assign the schema validation expression to the cmd variable
cmd = OrderedDict([
    ('collMod','scanResult'),
    ('validator', vexpr),
    ('validationLevel','moderate')
])


try:
    db.command(cmd)
    print("Check whether valdiation works: All good")
except Exception as e:
    print("exc",e)


with open(f'{__file__}\\..\\data_scanResult.json') as file:
        file_data = json.load(file)
database_utils.add_document("scanResult",file_data)

    
# document = database_utils.find_document("scanResult", {})
# print(list(document))


# database_utils.delete_document("scanResult", {"website":"example.com"})


# database_utils.edit_document("scanResult", {"website":"example2.com"},{"$set":{"website":"example4.com"}})


# Disconnect from the database
database_utils.disconnect()