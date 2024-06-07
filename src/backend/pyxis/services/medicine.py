from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.dispenser import Medicine
import json
import qrcode
from io import BytesIO
import asyncio
from concurrent.futures import ThreadPoolExecutor

async def fetch_medicine_by_id(session: AsyncSession, medicine_id: int):
    print('eU SOU O SERVICO DE MEDICAMENTO E EU RECEBI ', str(medicine_id))
    stmt = select(Medicine).where(Medicine.id == medicine_id)
    result = await session.execute(stmt)
    return result.scalars().first().to_dict()