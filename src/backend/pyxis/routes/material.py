from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.dispenser import Material
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.material import fetch_material_by_id

router = APIRouter(prefix="/materials")

@router.get("/{material_id}")
async def read_material_by_id(material_id: int, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    material = await fetch_material_by_id(session, material_id)
    if not material:
        raise HTTPException(status_code=404, detail="Material not found")
    return material