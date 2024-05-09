from fastapi import APIRouter, HTTPException, status, Depends
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession
from services.auth import hash_password, create_access_token
from services.users import get_users, get_user_by_email, get_user_by_id, create_user
from database import get_session  # make sure to have this function defined in your database module
from models.schemas import UserRegistrationRequest, UserResponseModel

router = APIRouter()

@router.post("/register", response_model=UserResponseModel)  # define UserResponseModel to control what gets returned
async def register(request: UserRegistrationRequest, session: AsyncSession = Depends(get_session)):
    user = await get_user_by_email(session, request.email)
    if user:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email already registered")
    
    hashed_password = hash_password(request.password)
    user = await create_user(session, request.email, hashed_password, request.role)
    return UserResponseModel(id=user['id'], email=user['email'], role=user['role'])
