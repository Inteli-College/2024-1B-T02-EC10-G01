from fastapi import APIRouter, HTTPException, status, Depends
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession
from services.auth import hash_password, create_access_token, verify_password
from services.users import get_users, get_user_by_email, get_user_by_id, create_user, update_user_with_mobile_token
from database import get_session  # make sure to have this function defined in your database module
from models.schemas import UserRegistrationRequest, UserResponseModel, LoginResponseModel, UserLoginRequest

router = APIRouter()

@router.post("/register", response_model=UserResponseModel)  
async def register(request: UserRegistrationRequest, session: AsyncSession = Depends(get_session)):
    user = await get_user_by_email(session, request.email)
    if user:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email already registered")
    
    hashed_password = hash_password(request.password)
    user = await create_user(session, request.email, hashed_password, request.role)
    return UserResponseModel(id=user['id'], email=user['email'], role=user['role'])

@router.post("/login", response_model=LoginResponseModel)
async def login(request: UserLoginRequest, session: AsyncSession = Depends(get_session)):
    user = await get_user_by_email(session, request.email)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    if not verify_password(request.password, user['password_hash']):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid password")
    
    await update_user_with_mobile_token(session, request.email, request.mobile_token)

    access_token = create_access_token(data={"sub": user['email'], "role": user['role'], "mobile_token": request.mobile_token})
    return LoginResponseModel(email=user['email'], access_token=access_token, token_type="bearer", mobile_token=request.mobile_token)

@router.get("/users/{user_email}", response_model=UserResponseModel)
async def get_user(user_email: str, session: AsyncSession = Depends(get_session)):
    user = await get_user_by_email(session, user_email)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return UserResponseModel(id=user['id'], email=user['email'], role=user['role'], mobile_token=user['mobile_token'])


