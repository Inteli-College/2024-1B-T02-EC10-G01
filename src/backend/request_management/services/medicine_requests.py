from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from backend.request_management.models.medicine_requests import MedicineRequest
from fastapi import HTTPException
import aiohttp
import asyncio

async def _fetch_medicine_data(medicine_id: int, session: aiohttp.ClientSession):
    url = f"http://localhost:8000/pyxis/medicine/{medicine_id}"
    try:
        async with session.get(url) as response:
            if response.status == 200:
                return await response.json()  # Assuming JSON response
            else:
                error_message = await response.text()
                raise HTTPException(status_code=response.status, detail=error_message)
    except aiohttp.ClientError as e:
        raise HTTPException(status_code=503, detail=f"Unable to reach the medicine service: {str(e)}")

async def fetch_requests(session: AsyncSession):
    stmt = select(MedicineRequest)
    result = await session.execute(stmt)
    return result.scalars().all()

async def create_requests(request: MedicineRequest, session: AsyncSession):
    async with aiohttp.ClientSession() as http_session:
        tasks = [_fetch_medicine_data(request.dispenser_id, http_session)]
        results = await asyncio.gather(*tasks, return_exceptions=True)
        return results