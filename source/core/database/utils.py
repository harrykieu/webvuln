from pymongo import MongoClient 
import os

class DatabaseUtils:
    def __init__(self):
        """constructor to open and connect to connect database webvuln in mongodb
        so that we can call the database in all other function in the same class with self.db...
        - self.client = ... : initialize a MongoDB client object  retrieving the database connection URI  
        - self.db = .... to get the database webvuln in mongodb
        """
        self.client = MongoClient(os.getenv("DATABASE_URI"))
        self.db = self.client.get_database("webvuln")

    def addDocument(self, collection_name,data):
        """
        function to add a document to the collection in the database
        collection_name: name of the collection
        data: data of the document
        if there is more than one document then use insert_many(), else use insert_one()
        """
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
            
    def deleteDocument(self, collection_name, query):
        """
        function to delete one document from the collection 
        query: this parameter is used to be a dictionary that specifies the criteria for finding the 
        document to be deleted. the folmat will be {"field_name:field_value"}
        for example: {"domain":"example.com"}
        """
        try:
            collection = self.db.get_collection(collection_name)
            collection.delete_one(query)
            print("delete document successfully !")
        except Exception as e:
            print("exc",e) 
            
    def editDocument(self, collection_name, query, update):
        """
        function to edit the document 
        collection and query like the function above 
        - update: input the the new value for the fielde. The format will be {"$set":{"field_name":"field_value"} 
        """
        try:
            collection = self.db.get_collection(collection_name)
            collection.update_one(query, update)
            print("edit document successfully !")
        except Exception as e:
            print("exc",e) 
            
    def findDocument(self, collection_name, query):
        """
        function to find the document by the query and return the document that we have found 
        """
        try: 
            collection = self.db.get_collection(collection_name)
            return collection.find(query)
        except Exception as e:
            print("exc",e) 
            
    def disconnect(self):
        """
        disconnect from the database
        """
        self.client.close()


