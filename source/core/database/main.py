from pymongo import MongoClient 
from bson.objectid import ObjectId
from datetime import datetime, timezone
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


with open('webvuln\\source\\core\\database\\web_vuln.json','r') as j:
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


try:
    database_utils.add_document("web_collection")
except:
    print("exc",sys.exc_info())
    
    
# find documents
# try:
#     document = database_utils.find_document("web_collection", {})
#     print(list(document))
# except:
#     print("exc",sys.exc_info())

# try:
#     database_utils.delete_document("web_collection", {"website":"example.com"})
#     print("delete document successfully !")
# except:
#     print("exc",sys.exc_info())

# try:
#     database_utils.edit_document("web_collection", {"website":"example2.com"},{"$set":{"website":"example4.com"}})
#     print("edit document successfully !")
# except:
#     print("exc",sys.exc_info())


# Disconnect from the database
database_utils.disconnect()