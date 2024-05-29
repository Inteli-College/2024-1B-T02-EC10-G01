from fastapi import APIRouter
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.schemas import CreateMaterialRequest
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.material_requests import fetch_requests, create_request
import redis
import pickle

redis_client = redis.Redis(host='redis', port=6379, db=0)

router = APIRouter(prefix="/material")

@router.get("/")
async def read_material_requests(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    key = "read_material_requests"
    resultado = redis_client.get(key)
    if resultado:
        return pickle.loads(resultado)
    requests = await fetch_requests(session)
    # Store the fetched data in Redis before returning
    redis_client.setex(key, 120, pickle.dumps(requests))
    return [request.to_dict() for request in requests]

@router.post("/")
async def create_material_request(request: CreateMaterialRequest, session: AsyncSession = Depends(get_session), user: dict = Depends(is_nurse)):
    created_request = await create_request(session, request, user)
    requests = await fetch_requests(session)
    redis_client.setex("read_material_requests", 120, pickle.dumps(requests))
    return created_request