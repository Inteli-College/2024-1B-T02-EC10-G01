from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.dispenser import Dispenser
from io import BytesIO
from fastapi.responses import StreamingResponse
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.dispenser import fetch_dispensers, fetch_dispenser_by_id, generate_qr_code
import redis
import pickle

redis_client = redis.Redis(host='redis', port=6379, db=0)

router = APIRouter(prefix="/dispensers")

@router.get("/")
async def read_dispensers(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    key = "read_dispensers"
    resultado = redis_client.get(key)
    if resultado:
        return pickle.loads(resultado)
    dispensers = await fetch_dispensers(session)
    redis_client.setex(key, 120, pickle.dumps(dispensers))
    return [dispenser.to_dict() for dispenser in dispensers]

@router.get("/{dispenser_id}/qr")
async def get_dispenser_qr(dispenser_id: int, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    key = "get_dispenser_qr"
    resultado = redis_client.get(key)
    if resultado:
        return pickle.loads(resultado)
    dispenser = await fetch_dispenser_by_id(session, dispenser_id)
    if not dispenser:
        raise HTTPException(status_code=404, detail="Dispenser not found")
    img_byte_array = generate_qr_code({"dispenser_id": dispenser.id, "code": dispenser.code, "floor": dispenser.floor})
    redis_client.setex(key, 120, pickle.dumps(img_byte_array))
    return StreamingResponse(img_byte_array, media_type="image/png")

@router.get("/{dispenser_id}")
async def read_dispenser(dispenser_id: int, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    key = "read_dispenser_by_id"
    resultado = redis_client.get(key)
    if resultado:
        return pickle.loads(resultado)
    dispenser = await fetch_dispenser_by_id(session, dispenser_id)
    if not dispenser:
        raise HTTPException(status_code=404, detail="Dispenser not found")
    redis_client.setex(key, 120, pickle.dumps(dispenser))
    return dispenser.to_dict()