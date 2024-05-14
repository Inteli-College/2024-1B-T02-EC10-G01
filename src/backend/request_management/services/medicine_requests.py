from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.medicine_requests import MedicineRequest
from models.schemas import CreateMedicineRequest, MedicineRequestSchema
from fastapi import HTTPException
import aiohttp
import asyncio
import os
import json

gateway_url = os.getenv("GATEWAY_URL", "http://localhost:8000")

with open('./services/token.json', 'r') as file:
    token = json.load(file)['token']
    

async def _fetch_dispenser_data(dispenser_id: int, session: aiohttp.ClientSession):
    url = f"{gateway_url}/pyxis/dispensers/{dispenser_id}"
    headers = {"Authorization": f"Bearer {token}"}
    try:
        async with session.get(url, headers=headers) as response:
            if response.status == 200:
                return await response.json()  # Assuming JSON response
            else:
                error_message = await response.text()
                raise HTTPException(status_code=response.status, detail=error_message)
    except aiohttp.ClientError as e:
        raise HTTPException(status_code=503, detail=f"Unable to reach the medicine service: {str(e)}")
    
async def _fetch_medicine_data(medicine_id: int, session: aiohttp.ClientSession):
    url = f"{gateway_url}/pyxis/medicines/{medicine_id}"
    headers = {"Authorization": f"Bearer {token}"}
    try:
        async with session.get(url, headers=headers) as response:
            if response.status == 200:
                return await response.json()  # Assuming JSON response
            else:
                error_message = await response.text()
                raise HTTPException(status_code=response.status, detail=error_message)
    except aiohttp.ClientError as e:
        raise HTTPException(status_code=503, detail=f"Unable to reach the medicine service: {str(e)}")
    
async def _fetch_user_data(user_id: int, session: aiohttp.ClientSession):
    url = f"{gateway_url}/auth/users/{user_id}"
    headers = {"Authorization": f"Bearer {token}"}
    try:
        async with session.get(url, headers=headers) as response:
            if response.status == 200:
                return await response.json()  # Assuming JSON response
            else:
                error_message = await response.text()
                raise HTTPException(status_code=response.status, detail=error_message)
    except aiohttp.ClientError as e:
        raise HTTPException(status_code=503, detail=f"Unable to reach the auth service: {str(e)}")

async def fetch_requests(session: AsyncSession):
    stmt = select(MedicineRequest)
    result = await session.execute(stmt)
    return result.scalars().all()

async def create_request(request: CreateMedicineRequest, session: AsyncSession, response_model=MedicineRequestSchema):
    async with aiohttp.ClientSession() as http_session:
        tasks = [_fetch_dispenser_data(request.dispenser_id, http_session),
                  _fetch_medicine_data(request.medicine_id, http_session), _fetch_user_data(request.requested_by, http_session)]
        results = await asyncio.gather(*tasks, return_exceptions=True)
        dispenser = results[0]
        medicine = results[1]
        user = results[2]
        print(results)
        # add the request to the database
        new_request = MedicineRequest(dispenser_id=dispenser['id'], medicine_id=medicine['id'], requested_by=user['id'])
        session.add(new_request)
        await session.commit()
        await session.refresh(new_request)
        return response_model(id=new_request.id, dispenser=dispenser, medicine=medicine, requested_by=user, status=new_request.status)
