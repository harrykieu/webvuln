import base64
from datetime import datetime
import platform
from source.core.database.dbutils import DatabaseUtils
from pathlib import Path


def main():
    if platform.system() == "Windows":
        ROOTPATH = f"{Path(__file__).parent}\\setupAssets"
    else:
        ROOTPATH = f"{Path(__file__).parent}/setupAssets"
    db = DatabaseUtils()

    for folder in Path(ROOTPATH).iterdir():
        if folder.is_dir():
            # Normal resource
            print(f"[+] Adding {folder.name} resources to database...")
            if folder.name != "fileUpload":
                for file in folder.iterdir():
                    if file.name.__contains__("Parameter"):
                        typeJSON = "parameter"
                    elif file.name.__contains__("Payload"):
                        typeJSON = "payload"
                    else:
                        raise Exception("Invalid resource type!")
                    with open(file, "r") as f:
                        data = f.read()
                    f.close()
                    for line in data.splitlines():
                        newDocument = {
                            "vulnType": folder.name,
                            "type": f"{typeJSON}",
                            "value": line,
                            "createdDate": datetime.now(),
                            "editedDate": datetime.now(),
                        }
                        db.addDocument("resources", newDocument)
            # File resource
            else:
                for subfol in folder.iterdir():
                    for file in subfol.iterdir():
                        with open(file, "rb") as f:
                            data = f.read()
                        f.close()
                        newDocument = {
                            "fileName": file.name,
                            "description": subfol.name,
                            "base64value": base64.b64encode(data).decode(),
                            "createdDate": datetime.now(),
                            "editedDate": datetime.now(),
                        }
                        db.addDocument("fileResources", newDocument)
            print(f"[+] {folder.name} resources added!")
    print("[!] Done!")


if __name__ == "__main__":
    main()
