from fastapi import APIRouter, HTTPException, status, Depends
from services.auth import hash_password, create_access_token
from services.users import get_users, get_user_by_email, get_user_by_id, create_user

router = APIRouter()

@router.post("/register")
async def register(request: dict):
    email = request.get('email')
    password = request.get('password')
    role = request.get('role')

    user = await get_user_by_email(email)
    if user:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email already registered")
    
    hashed_password = hash_password(password)
    user = await create_user(email, hashed_password, role)
    return user
