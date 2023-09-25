from pymongo import MongoClient 
from bson.objectid import ObjectId
from collections import OrderedDict
import sys
import json
import  utils 

client = MongoClient("mongodb://localhost:27017")


db = client.webvuln
db.web_collection.drop()
db.create_collection("web_collection")
database_utils = utils.DatabaseUtils()
web_collection = db["web_collection"]


with open(f'{__file__}\\..\\web_vuln.json','r') as j:
    vexpr = {"$jsonSchema":json.load(j)}

# assign the schema validation expression to the cmd variable
cmd = OrderedDict([
    ('collMod','web_collection'),
    ('validator', vexpr),
    ('validationLevel','moderate')
])


try:
    db.command(cmd)
    print("Check whether valdiation works: All good")
except Exception as e:
    print("exc",e)


with open(f'{__file__}\\..\\data.json') as file:
        file_data = json.load(file)
database_utils.add_document("web_collection",file_data)

    
    
# find documents
# document = database_utils.find_document("web_collection", {})
# print(list(document))


# database_utils.delete_document("web_collection", {"website":"example.com"})
# print("delete document successfully !")


# database_utils.edit_document("web_collection", {"website":"example2.com"},{"$set":{"website":"example4.com"}})
# print("edit document successfully !")


# Disconnect from the database
database_utils.disconnect()