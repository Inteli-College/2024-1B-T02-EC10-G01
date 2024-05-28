from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.dispenser import Material
import json
import qrcode
from io import BytesIO
import asyncio
from concurrent.futures import ThreadPoolExecutor

async def fetch_material_by_id(session: AsyncSession, material_id: int):
    stmt = select(Material).where(Material.id == material_id)
    result = await session.execute(stmt)
    return result.scalars().first().to_dict()