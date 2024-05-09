from passlib.context import CryptContext
from jose import jwt
from datetime import datetime, timedelta

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

SECRET_KEY = "YOUR_SECRET_KEY"
ALGORITHM = "HS256"

with open("./services/private_key.pem", "rb") as key_file:
    private_key = key_file.read()

def hash_password(password: str):
    return pwd_context.hash(password)

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=15)  # Token validity
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, private_key, algorithm="RS256")
    return encoded_jwt