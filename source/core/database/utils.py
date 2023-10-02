from pymongo import MongoClient 
import os

class Database_utils:
    def __init__(self):
        self.client = MongoClient(os.getenv("DATABASE_URI"))
        self.db = self.client.get_database("webvuln")

    def disconnect(self):
        self.client.close()

    def add_document(self, collection_name,data):
        try:
            collection = self.db.get_collection(collection_name)
            if isinstance(data,list):
                collection.insert_many(data)
                print("Insert documents successfully!")
            else:
                collection.insert_one(data)
                print("Insert one document successfully!")
        except Exception as e:
            print("exc",e)   
            
    def delete_document(self, collection_name, query):
        try:
            collection = self.db.get_collection(collection_name)
            collection.delete_one(query)
            print("delete document successfully !")
        except Exception as e:
            print("exc",e) 
            
    def edit_document(self, collection_name, query, update):
        try:
            collection = self.db.get_collection(collection_name)
            collection.update_one(query, update)
            print("edit document successfully !")
        except Exception as e:
            print("exc",e) 
            
    def find_document(self, collection_name, query):
        try: 
            collection = self.db.get_collection(collection_name)
            return collection.find(query)
        except Exception as e:
            print("exc",e) 


