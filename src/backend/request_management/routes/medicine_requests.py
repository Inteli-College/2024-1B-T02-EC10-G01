from fastapi import APIRouter
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.schemas import CreateMedicineRequest
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.medicine_requests import fetch_requests, create_request, fetch_request, fetch_last_user_request
import redis
import pickle
import asyncio

redis_client = redis.Redis(host='redis', port=6379, db=0)

router = APIRouter(prefix="/medicine")

import json

@router.get("/")
async def read_medicine_requests(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    key = "read_medicine_requests"
    resultado = redis_client.get(key)
    if resultado:
        return json.loads(resultado)
    
    requests = await fetch_requests(session)
    request_dicts = [request.to_dict() for request in requests]
    redis_client.setex(key, 60, json.dumps(request_dicts))
    return request_dicts

@router.post("/")
async def create_medicine_request(request: CreateMedicineRequest, session: AsyncSession = Depends(get_session), user: dict = Depends(is_nurse)):
    key = "read_medicine_requests"
    created_request = await create_request(session, request, user)
    print(f"Created request: {created_request}")
    
    # Update cache with the new list of requests after adding the new one
    requests = await fetch_requests(session)
    request_dicts = [request.to_dict() for request in requests]
    redis_client.setex(key, 60, json.dumps(request_dicts))
    return created_request.to_dict()



@router.get("/last")
async def read_last_medicine_request(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    request = await fetch_last_user_request(session, user)
    return request

@router.get("/{id}")
async def read_medicine_request(id: int, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    request = await fetch_request(session, id, user)
    return request if request else None

