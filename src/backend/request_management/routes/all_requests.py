from fastapi import APIRouter
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.schemas import CreateMaterialRequest
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.all_requests import fetch_latest_request
import redis
import json


router = APIRouter(prefix="/last")

@router.get("/")
async def read_last(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
   
    
    request= await fetch_latest_request(session, user)
    return request