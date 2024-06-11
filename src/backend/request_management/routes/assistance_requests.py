from fastapi import APIRouter
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.schemas import CreateAssistanceRequest
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.assistance_requests import fetch_requests, create_request
import redis
import json

redis_client = redis.Redis(host='redis', port=6379, db=0)

router = APIRouter(prefix="/assistance")

@router.get("/")
async def read_assistance_requests(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    key = "read_assistance_requests"
    resultado = redis_client.get(key)
    if resultado:
        return json.loads(resultado)
    
    requests = await fetch_requests(session)
    request_dicts = [request.to_dict() for request in requests]
    redis_client.setex(key, 60, json.dumps(request_dicts))
    return request_dicts

@router.post("/")
async def create_assistance_request(request: CreateAssistanceRequest, session: AsyncSession = Depends(get_session), user: dict = Depends(is_nurse)):
    key = 'read_assistance_requests'
    created_request = await create_request(session, request, user)
    
    requests = await fetch_requests(session)
    request_dicts = [request.to_dict() for request in requests]
    redis_client.setex(key, 60, json.dumps(request_dicts))
    return created_request.to_dict()