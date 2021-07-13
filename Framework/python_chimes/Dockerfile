# syntax=docker/dockerfile:1
FROM python:3.8-slim-buster

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

WORKDIR /app
COPY . .

CMD [ "radio_chimes.py"]

ENTRYPOINT [ "python3" ]
