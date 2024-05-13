from fastapi import APIRouter
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.pyxis_requests import MedicineRequest
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.medicine_requests import fetch_requests

router = APIRouter(prefix="/medicine_requests")

@router.get("/")
async def read_medicine_requests(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    requests = await fetch_requests(session)
    return [request.to_dict() for request in requests]