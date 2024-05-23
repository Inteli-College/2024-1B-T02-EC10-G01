from fastapi import APIRouter
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.medicine_requests import StatusChange
from models.schemas import CreateMedicineRequest, UpdateStatus
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.status import update_status

router = APIRouter(prefix="/status")

@router.put("/")
async def update_request_status(request: UpdateStatus, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    request = await update_status(session, request)
    return request