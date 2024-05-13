from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.pyxis_requests import MedicineRequest

async def fetch_requests(session: AsyncSession):
    stmt = select(MedicineRequest)
    result = await session.execute(stmt)
    return result.scalars().all()