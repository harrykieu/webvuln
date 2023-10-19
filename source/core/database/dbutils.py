import json
from pymongo import MongoClient
import os
import source.core.utils as utils
from dotenv import load_dotenv


class DatabaseUtils:
    """This class contains the functions to add, delete, find and edit the documents in the collection.
    """

    def __init__(self, username=None, password=None) -> None:
        """Open the connection to the database.
        - `username`: username of the database.
        - `password`: password of the database.
        """
        load_dotenv()
        self.__client = MongoClient(os.getenv("DATABASE_URI"))
        self.__db = self.__client.get_database("webvuln")
        if not "resources" in self.__db.list_collection_names():
            self.__db.create_collection("resources", validator={
                                        '$jsonSchema': json.load(open("./source/core/schema/resources.json"))})
        if not "scanResult" in self.__db.list_collection_names():
            self.__db.create_collection("scanResult", validator={
                                        '$jsonSchema': json.load(open("./source/core/schema/scanResult.json"))})

    def addDocument(self, collectionName, data) -> bool:
        """Add a document to the collection in the database.
        - `collectionName`: name of the collection.
        - `data`: data of the document. 
        If there is more than one document, this function inserts the data using `insert_many()`, otherwise it uses `insert_one()`.
        """
        try:
            collection = self.__db.get_collection(collectionName)
            if isinstance(data, list):
                collection.insert_many(data)
                return True
            else:
                collection.insert_one(data)
                return True
        except Exception as e:
            utils.log(f'Error: {e}', "ERROR")
            raise e

    def deleteDocument(self, collectionName, query):
        """Delete one document from the collection.
        - `collectionName`: name of the collection.
        - `query`: a dictionary that specifies the criteria for finding the document to be deleted. 
        The format is `{"field_name:field_value"}`. Example: `{"domain":"example.com"}`
        """
        try:
            collection = self.__db.get_collection(collectionName)
            collection.delete_one(query)
            return "Success"
        except Exception as e:
            utils.log(f'Error: {e}', "ERROR")
            return "Failed"

    def updateDocument(self, collectionName, query, update):
        """Edit one document from the collection.
        - `collectionName`: name of the collection.
        - `query`: a dictionary that specifies the criteria for finding the document to be edited. 
        The format is `{"field_name:field_value"}`. Example: `{"domain":"example.com"}`.
        - `update`: a dictionary that specifies the field to be updated and the new value. 
        The format will be `{"$set":{"field_name":"field_value"}}`. Example: `{"$set":{"domain":"example.com"}}`.
        """
        try:
            collection = self.__db.get_collection(collectionName)
            collection.update_one(query, update)
            print("edit document successfully !")
        except Exception as e:
            print("exc", e)

    def findDocument(self, collectionName, query):
        """Find one document from the collection.
        - `collectionName`: name of the collection.
        - `query`: a dictionary that specifies the criteria for finding the document.
        The format is `{"field_name:field_value"}`. Example: `{"domain":"example.com"}`.
        """
        try:
            collection = self.__db.get_collection(collectionName)
            return collection.find(query)
        except Exception as e:
            print("exc", e)

    def disconnect(self):
        """Disconnect from the database.
        """
        self.__client.close()
