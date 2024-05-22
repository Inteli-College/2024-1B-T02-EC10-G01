from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.dispenser import Assistance
import json
import qrcode
from io import BytesIO
import asyncio
from concurrent.futures import ThreadPoolExecutor

async def fetch_assistance_by_id(session: AsyncSession, assistance_id: int):
    stmt = select(Assistance).where(Assistance.id == assistance_id)
    result = await session.execute(stmt)
    return result.scalars().first().to_dict()