from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.material_requests import MaterialRequest, MaterialStatusChange
from models.schemas import CreateMaterialRequest, MaterialRequestSchema
from fastapi import HTTPException
import aiohttp
import asyncio
import os
import json
from middleware import is_nurse, is_agent, is_admin
import pika

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
        raise HTTPException(status_code=503, detail=f"Unable to reach the material service: {str(e)}")
    
async def _fetch_material_data(material_id: int, session: aiohttp.ClientSession):
    url = f"{gateway_url}/pyxis/materials/{material_id}"
    headers = {"Authorization": f"Bearer {token}"}
    try:
        async with session.get(url, headers=headers) as response:
            if response.status == 200:
                return await response.json()  # Assuming JSON response
            else:
                error_message = await response.text()
                raise HTTPException(status_code=response.status, detail=error_message)
    except aiohttp.ClientError as e:
        raise HTTPException(status_code=503, detail=f"Unable to reach the material service: {str(e)}")
    
async def _fetch_user_data(user_email: str, session: aiohttp.ClientSession):
    url = f"{gateway_url}/auth/users/{user_email}"
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
    stmt = select(MaterialRequest)
    result = await session.execute(stmt)
    return result.scalars().all()

async def create_request(session: AsyncSession, request: CreateMaterialRequest, user: dict):
    async with aiohttp.ClientSession() as http_session:
        tasks = [_fetch_dispenser_data(request.dispenser_id, http_session),
                  _fetch_material_data(request.material_id, http_session), _fetch_user_data(user['sub'], http_session)]
        try:
            results = await asyncio.gather(*tasks, return_exceptions=True)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to fetch data: {str(e)}")

        # Check for HTTPException errors in results
        for result in results:
            if isinstance(result, HTTPException):
                raise result  # Raise the HTTPException
                
        # If no HTTPException, extract data from results
        dispenser, material, user = results
        

        # add the request to the database
        new_request = MaterialRequest(dispenser_id=dispenser['id'], material_id=material['id'], requested_by=user['id'])
        session.add(new_request)
        await session.commit()
        new_status = MaterialStatusChange(request_id=new_request.id)
        session.add(new_status)
        await session.commit()

        
        return new_request
    
async def fetch_request(session: AsyncSession, request_id: int, user: dict):    
    async with aiohttp.ClientSession() as http_session:
        stmt = select(MaterialRequest).where(MaterialRequest.id == request_id)
        result = await session.execute(stmt)
        request_result = result.scalar()


        tasks = [_fetch_dispenser_data(request_result.dispenser_id, http_session),
                    _fetch_material_data(request_result.material_id, http_session), 
                    _fetch_user_data(user['sub'], http_session)]
        try:
            results = await asyncio.gather(*tasks, return_exceptions=True)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to fetch data: {str(e)}")

        # Check for HTTPException errors in results
        for result in results:
            if isinstance(result, HTTPException):
                raise result  # Raise the HTTPException

        # If no HTTPException, extract data from results
        dispenser, material, user = results

        request = {
            "id": request_result.id,
            "dispenser": dispenser,
            "item": material,
            "requested_by": user,
            "status_changes": request_result.status_changes,
            "created_at": request_result.created_at,
            "feedback": request_result.feedback,
            "assign_to": request_result.assign_to
        }
        return request
    
async def fetch_last_user_request(session: AsyncSession, user: dict):
    async with aiohttp.ClientSession() as http_session:
        stmt = select(MaterialRequest).where(MaterialRequest.requested_by == user['id']).order_by(MaterialRequest.id.desc()).limit(1)
        result = await session.execute(stmt)
        request_result = result.scalar()

        tasks = [_fetch_dispenser_data(request_result.dispenser_id, http_session),
                    _fetch_material_data(request_result.medicine_id, http_session), 
                    _fetch_user_data(user['sub'], http_session)]
        try:
            results = await asyncio.gather(*tasks, return_exceptions=True)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to fetch data: {str(e)}")

        # Check for HTTPException errors in results
        for result in results:
            if isinstance(result, HTTPException):
                raise result  # Raise the HTTPException

        # If no HTTPException, extract data from results
        dispenser, medicine, user = results
        request = {
            "id": request_result.id,
            "dispenser": dispenser,
            "medicine": medicine,
            "requested_by": user,
            "created_at": request_result.created_at,
            "feedback": request_result.feedback,
            "assign_to": request_result.assign_to,
            "status_changes": request_result.status_changes
        }
        return request
    
async def create_feedback(session: AsyncSession, request: CreateMaterialRequest, user: dict):     
    stmt = select(MaterialRequest).where(MaterialRequest.id == request.request_id)
    result = await session.execute(stmt)
    material_request = result.scalars().first()

    if not material_request:
        raise HTTPException(status_code=404, detail="Material request not found")

    # Update the feedback column
    material_request.feedback = request.feedback

    # Commit the changes to the database
    session.add(material_request)
    await session.commit()
    await session.refresh(material_request)

    return material_request