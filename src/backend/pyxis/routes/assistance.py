from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.dispenser import Assistance
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.assistance import fetch_assistance_by_id

router = APIRouter(prefix="/assistances")

@router.get("/{assistance_id}")
async def read_assistance_by_id(assistance_id: int, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    assistance = await fetch_assistance_by_id(session, assistance_id)
    if not assistance:
        raise HTTPException(status_code=404, detail="Assistance not found")
    return assistance
