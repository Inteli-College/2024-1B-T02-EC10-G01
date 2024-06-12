from sqlalchemy import union_all, literal
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.medicine_requests import MedicineRequest, MedicineStatusChange
from models.material_requests import MaterialRequest, MaterialStatusChange
from models.schemas import CreateMedicineRequest, MedicineRequestSchema
from fastapi import HTTPException
import aiohttp
import asyncio
import os
import json
from middleware import is_nurse, is_agent, is_admin
import pika
from services.notifications import publish_notification_by_role
import datetime

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
    
async def _fetch_status_changes(request_id: int, type: str, session: AsyncSession):
    if type == "medicine":
        stmt = select(MedicineStatusChange).filter(MedicineStatusChange.request_id == request_id)
    else:
        stmt = select(MaterialStatusChange).filter(MaterialStatusChange.request_id == request_id)
    
    result = await session.execute(stmt)
    status_changes = result.scalars().all()
    return status_changes

async def fetch_latest_request(session: AsyncSession, user: dict):
    async with aiohttp.ClientSession() as http_session:
        # Create a union of the two request tables
        medicine_query = (
            select(
                MedicineRequest.id,
                MedicineRequest.dispenser_id,
                MedicineRequest.medicine_id,
                MedicineRequest.created_at,
                MedicineRequest.batch_number,
                MedicineRequest.emergency,
                literal("medicine").label("request_type")
            )
        )

        material_query = (
            select(
                MaterialRequest.id,
                MaterialRequest.dispenser_id,
                MaterialRequest.material_id,
                MaterialRequest.created_at,
                literal(None).label("batch_number"),  # No batch_number for material requests
                literal(None).label("emergency"),
                literal("material").label("request_type")
            )
        )

        union_query = union_all(medicine_query, material_query).alias("combined_requests")
        stmt = select(union_query).order_by(union_query.c.created_at.desc()).limit(1)
        
        result = await session.execute(stmt)
        request_result = result.fetchone()

        if not request_result:
            raise HTTPException(status_code=404, detail="No requests found")

        request_type = request_result[-1]
        if request_type == "medicine":
            request_dict = {
                "id": request_result[0],
                "dispenser_id": request_result[1],
                "medicine_id": request_result[2],
                "created_at": request_result[4],
                "batch_number": request_result[5],
                "emergency": request_result[6],
                "request_type": request_type
            }
        else:
            request_dict = {
                "id": request_result[0],
                "dispenser_id": request_result[1], # No dispenser_id for material requests
                "material_id": request_result[2],
                "created_at": request_result[4],
                "batch_number": None,  # No batch_number for material requests
                "emergency": None,
                "request_type": request_type
            }
        
        dispenser_id = request_dict.get("dispenser_id")
        
        if dispenser_id is not None:
            dispenser_data_task = _fetch_dispenser_data(int(dispenser_id), http_session)
        else:
            dispenser_data_task = None

        if request_type == "medicine":
            item_data_task = _fetch_medicine_data(int(request_dict['medicine_id']), http_session)
        else:
            item_data_task = _fetch_material_data(int(request_dict['material_id']), http_session)  # Adjust to fetch material data

        user_data_task = _fetch_user_data(user['sub'], http_session)
        
        status_changes_task = _fetch_status_changes(request_dict['id'], request_type, session)

        tasks = [dispenser_data_task, item_data_task, user_data_task, status_changes_task]
    
        try:
            results = await asyncio.gather(*tasks, return_exceptions=True)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to fetch data: {str(e)}")

        for result in results:
            if isinstance(result, HTTPException):
                raise result

        dispenser = results[0] 
        item = results[1]
        user_data = results[2]
        status_changes = results[3]

        request = {
            "id": request_dict['id'],
            "dispenser": dispenser,
            "item": item,
            "requested_by": user_data,
            "status_changes": status_changes,
            "created_at": request_dict['created_at'],
            "batch_number": request_dict['batch_number'] if request_type == "medicine" else None,
            "emergency": request_dict['emergency'],
            "request_type": request_dict['request_type']
        }
        print('oi ')
        print(f"last Request: {request}")
        return request
