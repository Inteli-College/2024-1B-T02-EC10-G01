from fastapi import APIRouter
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.schemas import CreateAssistanceRequest, CreateAssistanceFeedback, AssignAssistanceRequest
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.assistance_requests import fetch_requests, create_request, create_feedback, fetch_request_by_id, assign_request
import redis
import json

redis_client = redis.Redis(host='redis', port=6379, db=0)

router = APIRouter(prefix="/assistance")

@router.get("/")
async def read_assistance_requests(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    key = "read_assistance_requests"
    # resultado = redis_client.get(key)
    # if resultado:
    #     return json.loads(resultado)
    
    requests = await fetch_requests(session)
    request_dicts = [request.to_dict() for request in requests]
    # redis_client.setex(key, 60, json.dumps(request_dicts))
    return request_dicts

@router.post("/")
async def create_assistance_request(request: CreateAssistanceRequest, session: AsyncSession = Depends(get_session), user: dict = Depends(is_nurse)):
    # key = 'read_assistance_requests'
    created_request = await create_request(session, request, user)
    
    # requests = await fetch_requests(session)
    # request_dicts = [request.to_dict() for request in requests]
    # redis_client.setex(key, 60, json.dumps(request_dicts))
    return created_request

@router.get("/{id}")
async def fetch_by_id(id: int, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    key = "read_assistance_requests"
    # resultado = redis_client.get(key)
    # if resultado:
    #     return json.loads(resultado)
    
    request = await fetch_request_by_id(id, session, user)
    # request['']
    # redis_client.setex(key, 60, json.dumps(request_dicts))
    return request

@router.post("/feedback")
async def create_assistance_feedback(request: CreateAssistanceFeedback, session: AsyncSession = Depends(get_session), user: dict = Depends(is_agent)):
    key = 'read_assistance_requests'
    created_feedback = await create_feedback(session, request, user)
    return created_feedback

@router.post("/accept_request")
async def accept_assistance_request(request: AssignAssistanceRequest, session: AsyncSession = Depends(get_session), user: dict = Depends(is_agent)):
    key = 'read_assistance_requests'
    assigned_request = await assign_request(session, request, user)
    return assigned_request