from fastapi import APIRouter
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from backend.request_management.models.medicine_requests import MedicineRequest
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.medicine_requests import fetch_requests, create_request

router = APIRouter(prefix="/medicine_requests")

@router.get("/")
async def read_medicine_requests(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    requests = await fetch_requests(session)
    return [request.to_dict() for request in requests]

@router.post("/")
async def create_medicine_request(request: MedicineRequest, session: AsyncSession = Depends(get_session)):
    created_request = await create_request(request, session)
    return created_request