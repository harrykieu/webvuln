import pymongo
from pymongo import MongoClient
from datetime import datetime
import json 
import sys
from dotenv import load_dotenv
import os

class DatabaseUtils:
    def __init__(self, database_uri=os.getenv("DATABASE_URI")):
        self.client = MongoClient(database_uri)
        self.db = self.client.get_database("webvuln")

    def disconnect(self):
        self.client.close()

    def add_document(self, collection_name,file_data):
        try:
            collection = self.db.get_collection(collection_name)
            for document in file_data:
                document["date"] = datetime.now()
            if isinstance(file_data,list):
                collection.insert_many(file_data)
            else:
                collection.insert_one(file_data)
        except:
            print("exc",sys.exc_info())   
            
    def delete_document(self, collection_name, query):
        try:
            collection = self.db.get_collection(collection_name)
            collection.delete_one(query)
        except:
            print("exc",sys.exc_info()) 
            
    def edit_document(self, collection_name, query, update):
        try:
            collection = self.db.get_collection(collection_name)
            collection.update_one(query, update)
        except:
            print("exc",sys.exc_info()) 
            
    def find_document(self, collection_name, query):
        try: 
            collection = self.db.get_collection(collection_name)
            return collection.find(query)
        except:
            print("exc",sys.exc_info()) 
#  uri hay cac value khac ko dc de trong utils , truyen file data tu main.py
