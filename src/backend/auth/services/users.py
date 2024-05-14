from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.users import User
import json

async def get_users(session: AsyncSession):
    stmt = select(User)
    result = await session.execute(stmt)
    users = result.scalars().all()
    return [user.to_dict() for user in users]

async def get_user_by_email(session, email: str):
    stmt = select(User).filter(User.email == email)
    result = await session.execute(stmt)
    user = result.scalar()
    print(user.to_dict())
    return user.to_dict() if user else None

async def get_user_by_id(session, user_id: int):
    stmt = select(User).filter(User.id == user_id)
    result = await session.execute(stmt)
    user = result.scalar()
    user = user.to_dict() if user else None
    return {"id": user["id"], "email": user["email"], "role": user["role"]}

async def create_user(session, email: str, password_hash: str, role: str):
    user = User(email=email, password_hash=password_hash, role=role)
    session.add(user)
    user = await session.commit()
    user = await session.refresh(user)
    user = user.to_dict()
    return {"message": "User created successfully", "user": {"id": user["id"], "email": user["email"], "role": user["role"]}}
