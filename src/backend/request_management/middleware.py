import jwt
from jwt.exceptions import InvalidTokenError
from fastapi import HTTPException, Security, Depends, Header
from starlette.status import HTTP_401_UNAUTHORIZED, HTTP_403_FORBIDDEN
from sqlalchemy.exc import NoResultFound
import firebase_admin
from firebase_admin import credentials, messaging

def get_public_key():
    try:
        with open("public_key.pem", "rb") as key_file:
            return key_file.read()
    except FileNotFoundError:
        raise HTTPException(status_code=HTTP_403_FORBIDDEN, detail="Public key not found")

def verify_token(token: str = Security()):
    public_key = get_public_key()
    try:
        decoded_token = jwt.decode(token, public_key, algorithms=["RS256"])
        return decoded_token  # Token is valid
    except InvalidTokenError as e:
        raise HTTPException(status_code=HTTP_401_UNAUTHORIZED, detail="Invalid token")

async def get_current_user(authorization: str = Header(...)):
    try:
        scheme, token = authorization.split()
        if scheme.lower() != "bearer":
            raise ValueError("Authorization scheme not supported")
    except ValueError:
        raise HTTPException(status_code=HTTP_401_UNAUTHORIZED, detail="Invalid authorization header format.")
    
    user_info = verify_token(token)
    
    if user_info is None:
        raise HTTPException(status_code=HTTP_401_UNAUTHORIZED, detail="Invalid or expired token")
    return user_info

async def is_admin(authorization: str = Header(...)):
    user_info = await get_current_user(authorization)
    if user_info["role"] != "admin":
        raise HTTPException(status_code=HTTP_403_FORBIDDEN, detail="You are not authorized to access this resource.")
    return user_info

async def is_nurse(authorization: str = Header(...)):
    user_info = await get_current_user(authorization)
    if user_info["role"] != "nurse":
        raise HTTPException(status_code=HTTP_403_FORBIDDEN, detail="You are not authorized to access this resource.")
    return user_info

async def is_agent(authorization: str = Header(...)):
    user_info = await get_current_user(authorization)
    if user_info["role"] != "agent":
        raise HTTPException(status_code=HTTP_403_FORBIDDEN, detail="You are not authorized to access this resource.")
    return user_info
