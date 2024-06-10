# request_management/Dockerfile

FROM python:3.8-slim

WORKDIR /app

COPY requirements.txt .

COPY ./services/serviceAccountKey.json .

RUN pip install -r requirements.txt

COPY . .

CMD ["python", "main.py"]