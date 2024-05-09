from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.users import User
import json

async def get_users(session: AsyncSession = Depends(get_session)):
    stmt = select(User)
    result = await session.execute(stmt)
    users = result.scalars().all()
    return users

async def get_user_by_email(email: str, session = Depends(get_session)):
    print(session)
    print(type(session))
    stmt = select(User).filter(User.email == email)
    result = await session.execute(stmt)
    user = result.scalar()
    return user

async def get_user_by_id(user_id: int, session: AsyncSession = Depends(get_session)):
    stmt = select(User).filter(User.id == user_id)
    result = await session.execute(stmt)
    user = result.scalar()
    return user

async def create_user(user: User, session: AsyncSession = Depends(get_session)):
    session.add(user)
    await session.commit()
    return user

