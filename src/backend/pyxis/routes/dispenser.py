from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.dispenser import Dispenser
from io import BytesIO
from fastapi.responses import StreamingResponse
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.dispenser import fetch_dispensers, fetch_dispenser_by_id, generate_qr_code

router = APIRouter(prefix="/dispensers")

@router.get("/")
async def read_dispensers(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    dispensers = await fetch_dispensers(session)
    return [dispenser.to_dict() for dispenser in dispensers]

@router.get("/{dispenser_id}/qr")
async def get_dispenser_qr(dispenser_id: int, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    dispenser = await fetch_dispenser_by_id(session, dispenser_id)
    if not dispenser:
        raise HTTPException(status_code=404, detail="Dispenser not found")
    img_byte_array = generate_qr_code({"dispenser_id": dispenser.id, "code": dispenser.code, "floor": dispenser.floor})
    return StreamingResponse(img_byte_array, media_type="image/png")

@router.get("/{dispenser_id}")
async def read_dispenser(dispenser_id: int, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    dispenser = await fetch_dispenser_by_id(session, dispenser_id)
    if not dispenser:
        raise HTTPException(status_code=404, detail="Dispenser not found")
    return dispenser.to_dict()