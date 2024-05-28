from fastapi import APIRouter
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.schemas import CreateMedicineRequest, UpdateStatus
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.medicine_requests import fetch_requests
from services.status import update_assistance_status, update_material_status, update_medicine_status
import redis
import pickle

redis_client = redis.Redis(host='redis', port=6379, db=0)

router = APIRouter(prefix="/status")

@router.put("/medicine")
async def update_medicine_status_request(request: UpdateStatus, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    request = await update_medicine_status(session, request)
    requests = await fetch_requests(session)
    redis_client.setex("read_medicine_requests", 120, pickle.dumps(requests))
    return request

@router.put("/material")
async def update_material_status_request(request: UpdateStatus, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    request = await update_material_status(session, request)
    requests = await fetch_requests(session)
    redis_client.setex("read_material_requests", 120, pickle.dumps(requests))
    return request

@router.put("/assistance")
async def update_assistance_status_request(request: UpdateStatus, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    request = await update_assistance_status(session, request)
    requests = await fetch_requests(session)
    redis_client.setex("read_assistance_requests", 120, pickle.dumps(requests))
    return request
