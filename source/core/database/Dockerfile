# Base image
FROM python:3.11

RUN apt update 
RUN apt install python3 -y 

WORKDIR /usr/app/src

COPY database.py ./

RUN pip install pymongo

CMD ["python", "database.py"]