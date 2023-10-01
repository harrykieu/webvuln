from pymongo import MongoClient 
from pymongo import MongoClient
from datetime import datetime 
import sys
import os
from isodate import parse_datetime 
class Database_utils_scan:
    def __init__(self):
        self.client = MongoClient(os.getenv("DATABASE_URI"))
        self.db = self.client.get_database("webvuln")

    def disconnect(self):
        self.client.close()

    def add_document(self, collection_name,scanResult_data):
        try:
            collection = self.db.get_collection(collection_name)
            for document in scanResult_data:
                try:
                    document["scanDate"] = parse_datetime(document["scanDate"])
                except  Exception as e:
                    print("exc", e)
            if isinstance(scanResult_data,list):
                collection.insert_many(scanResult_data)
                print("Insert documents successfully!")
            else:
                collection.insert_one(scanResult_data)
                print("Insert document successfully!")
        except:
            print("exc",sys.exc_info())   
            
    def delete_document(self, collection_name, query):
        try:
            collection = self.db.get_collection(collection_name)
            collection.delete_one(query)
            print("delete document successfully !")
        except:
            print("exc",sys.exc_info()) 
            
    def edit_document(self, collection_name, query, update):
        try:
            collection = self.db.get_collection(collection_name)
            collection.update_one(query, update)
            print("edit document successfully !")
        except:
            print("exc",sys.exc_info()) 
            
    def find_document(self, collection_name, query):
        try: 
            collection = self.db.get_collection(collection_name)
            return collection.find(query)
        except:
            print("exc",sys.exc_info()) 


class Database_utils_resources:
    def __init__(self):
        self.client = MongoClient(os.getenv("DATABASE_URI"))
        self.db = self.client.get_database("webvuln")

    def disconnect(self):
        self.client.close()

    def add_document(self, collection_name,resources_data):
        try:
            collection = self.db.get_collection(collection_name)
            for document in resources_data:
                try:             
                    document["createdDate"] = parse_datetime(document["createdDate"])
                    document["editedDate"] = parse_datetime(document["editedDate"])
                except Exception as e:
                    print("exc", e)

            if isinstance(resources_data,list):
                collection.insert_many(resources_data)
                print("Insert documents successfully!")
            else:
                collection.insert_one(resources_data)
                print("Insert document successfully!")
        except Exception as e:
            print("exc",e)
            
    def delete_document(self, collection_name, query):
        try:
            collection = self.db.get_collection(collection_name)
            collection.delete_one(query)
            print("delete document successfully !")
        except:
            print("exc",sys.exc_info()) 
            
    def edit_document(self, collection_name, query, update):
        try:
            collection = self.db.get_collection(collection_name)
            collection.update_one(query, update)
            print("edit document successfully !")
        except:
            print("exc",sys.exc_info()) 
            
    def find_document(self, collection_name, query):
        try: 
            collection = self.db.get_collection(collection_name)
            return collection.find(query)
        except:
            print("exc",sys.exc_info()) 