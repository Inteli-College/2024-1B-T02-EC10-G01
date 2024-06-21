from fastapi import APIRouter
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.schemas import CreateMaterialRequest, CreateMaterialFeedback, AssignMaterialRequest, changeStatus
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.material_requests import fetch_requests, create_request, fetch_last_user_request, fetch_request, create_feedback, assign_request, update_status
import redis
import json

redis_client = redis.Redis(host='redis', port=6379, db=0)

router = APIRouter(prefix="/material")

@router.get("/")
async def read_material_requests(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    key = "read_material_requests"
    # resultado = redis_client.get(key)
    # if resultado:
    #     return json.loads(resultado)
    
    requests = await fetch_requests(session)
    request_dicts = [request.to_dict() for request in requests]
    # redis_client.setex(key, 60, json.dumps(request_dicts))
    return request_dicts

@router.post("/")
async def create_material_request(request: CreateMaterialRequest, session: AsyncSession = Depends(get_session), user: dict = Depends(is_nurse)):
    key = 'read_material_requests'
    created_request = await create_request(session, request, user)

    # requests = await fetch_requests(session)
    # request_dicts = [request.to_dict() for request in requests]
    # redis_client.setex(key, 60, json.dumps(request_dicts))
    return created_request

@router.get("/last")
async def read_last_material_request(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    request = await fetch_last_user_request(session, user)
    return request

@router.get("/{id}")
async def read_material(id: int, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    request = await fetch_request(session, id, user)
    return request if request else None

@router.post("/feedback")
async def create_material_feedback(request: CreateMaterialFeedback, session: AsyncSession = Depends(get_session), user: dict = Depends(is_agent)):
    key = 'read_material_requests'
    created_feedback = await create_feedback(session, request, user)
    return created_feedback

@router.post("/accept_request")
async def accept_material_request(request: AssignMaterialRequest, session: AsyncSession = Depends(get_session), user: dict = Depends(is_agent)):
    key = 'read_material_requests'
    assigned_request = await assign_request(session, request, user)
    return assigned_request

@router.post("/change_status/{request_id}")
async def change_status(request: changeStatus, request_id, session: AsyncSession = Depends(get_session), user: dict = Depends(is_agent)):
    changed_status = await update_status(session, request, user, request_id)
    return changed_status