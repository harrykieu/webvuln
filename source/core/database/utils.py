import pymongo
from pymongo import MongoClient
from datetime import datetime
import json 

class DatabaseUtils:
    def __init__(self, database_uri="mongodb://localhost:27017"):
        self.client = MongoClient(database_uri)
        self.db = self.client.get_database("webvuln")

    def disconnect(self):
        self.client.close()

    def add_document(self, collection_name):
        try:
            collection = self.db.get_collection(collection_name)
            with open('data.json') as file:
                file_data = json.load(file)
            for document in file_data:
                document["date"] = datetime.now()
            if isinstance(file_data,list):
                collection.insert_many(file_data)
            else:
                collection.insert_one(file_data)
        
    def delete_document(self, collection_name, query):
        collection = self.db.get_collection(collection_name)
        collection.delete_one(query)

    def edit_document(self, collection_name, query, update):
        collection = self.db.get_collection(collection_name)
        collection.update_one(query, update)

    def find_document(self, collection_name, query):
        collection = self.db.get_collection(collection_name)
        return collection.find(query)

# try except , uri hay cac value khac ko dc de trong utils , truyen file data tu main.py
# custom exception pythons