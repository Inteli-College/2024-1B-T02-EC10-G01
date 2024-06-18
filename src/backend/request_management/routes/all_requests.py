from fastapi import APIRouter
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.schemas import CreateMaterialRequest
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.all_requests import fetch_latest_request, fetch_all_requests_by_user, fetch_pending_requests
import redis
import json


router = APIRouter()

@router.get("/last")
async def read_last(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    request= await fetch_latest_request(session, user)
    return request

@router.get("/")
async def read_requests(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    requests = await fetch_all_requests_by_user(session, user)
    return requests

@router.get("/pending")
async def read_pending_requests(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    requests = await fetch_pending_requests(session, user)
    return requests
