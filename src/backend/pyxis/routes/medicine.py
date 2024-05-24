from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.dispenser import Medicine
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.medicine import fetch_medicine_by_id
import redis
import pickle

redis_client = redis.Redis(host='redis', port=6379, db=0)

router = APIRouter(prefix="/medicines")

@router.get("/{medicine_id}")
async def read_medicine_by_id(medicine_id: int, session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    key = "read_medicine_by_id"
    resultado = redis_client.get(key)
    if resultado:
        return pickle.loads(resultado)
    medicine = await fetch_medicine_by_id(session, medicine_id)
    if not medicine:
        raise HTTPException(status_code=404, detail="Medicine not found")
    redis_client.setex(key, 120, pickle.dumps(medicine))
    return medicine
