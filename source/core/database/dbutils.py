import json
import os

from dotenv import load_dotenv
from pymongo import MongoClient

import source.core.utils as utils


class DatabaseUtils:
    def __init__(self, username=None, password=None) -> None:
        """Open the connection to the database.
        - `username`: username of the database.
        - `password`: password of the database.
        """
        load_dotenv()

        database_uri = os.getenv("DATABASE_URI")

        if username is not None and password is not None: 
            database_uri = f"mongodb://{username}:{password}@{database_uri}"
            
        self.__client = MongoClient(database_uri)
        self.__db = self.__client.get_database("webvuln")

        if "resources" not in self.__db.list_collection_names():
            self.__db.create_collection(
                "resources",
                validator={
                    "$jsonSchema": json.load(
                        open("./source/core/schema/resources.json")
                    )
                },
            )
            self.__db.resources.create_index([("value",1),("vulnType",1)], unique=True)
        if "scanResult" not in self.__db.list_collection_names():
            self.__db.create_collection(
                "scanResult",
                validator={
                    "$jsonSchema": json.load(
                        open("./source/core/schema/scanResult.json")
                    )
                },
            )
        if "fileResources" not in self.__db.list_collection_names():
            self.__db.create_collection(
                "fileResources",
                validator={
                    "$jsonSchema": json.load(
                        open("./source/core/schema/fileResources.json")
                    )
                },
            )

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
            utils.log(f"[dbutils.py-addDocument] Error: {e}", "ERROR")
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
            return True
        except Exception as e:
            utils.log(f"[dbutils.py-deleteDocument] Error: {e}", "ERROR")
            raise e

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
            return True
        except Exception as e:
            utils.log(f"[dbutils.py-updateDocument] Error: {e}", "ERROR")
            raise e

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
            utils.log(f"[dbutils.py-findDocument] Error: {e}", "ERROR")
            raise e

    def disconnect(self):
        """Disconnect from the database."""
        self.__client.close()