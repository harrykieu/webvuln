from pymongo import MongoClient 
from bson.objectid import ObjectId
from datetime import datetime, timezone
from collections import OrderedDict
import sys
import json


client = MongoClient("mongodb://localhost:27017")


db = client.webvuln
db.web_collection.drop()
db.create_collection("web_collection")

# viet func them data xoa data sua data  tim data va connect database viet 1 file util.py trong source core database
# create new documents
web1 = {
     '_id': ObjectId(),
    'website': "example.com",
    'date' : datetime.now(tz=timezone.utc),
    'num_vul': 0,
    'vulnerability': [
    ],
    'severity': 'Low'
}
web2 = {
    '_id': ObjectId(),
    'website': "example2.com",
    'date' : datetime.now(tz=timezone.utc),
    'num_vul': 0,
    'vulnerability': [
    ],
    'severity': "Low"
}


webs = []
webs.append(web1)
webs.append(web2)

with open('webvuln\\source\\core\\database\\web_vuln.json','r') as j:
    vexpr = json.load(j)

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

web_collection = db["web_collection"]

try:
    for i in range(len(webs)):
        web_collection.insert_one(webs[i])
        print(f"Insert document {i+1} successfully !")
except:
    print("exc",sys.exc_info())