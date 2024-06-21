from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.medicine_requests import MedicineRequest, MedicineStatusChange, Status
from models.schemas import AssignMedicineRequest, CreateMedicineRequest, MedicineRequestSchema, changeStatus
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
    
async def _fetch_user_by_id(id: int, session: aiohttp.ClientSession):
    url = f"{gateway_url}/auth/users/id/{id}"
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
    
async def _fetch_status(status_id: int, session: AsyncSession):
    stmt = select(MedicineStatusChange).where(MedicineStatusChange.id == status_id)
    result = await session.execute(stmt)
    return result.scalar_one()

async def fetch_requests(session: AsyncSession):
    stmt = select(MedicineRequest)
    result = await session.execute(stmt)
    return result.scalars().all()

async def _update_status(request_id: int, session: aiohttp.ClientSession):
    url = f"{gateway_url}/requests/status/medicine"
    headers = {"Authorization": f"Bearer {token}"}
    body = {"id": request_id, "status": "accepted"}
    try:
        async with session.put(url, headers=headers, json=body) as response:
            if response.status == 200:
                return await response.json()  # Assuming JSON response
            else:
                error_message = await response.text()
                raise HTTPException(status_code=response.status, detail=error_message)
    except aiohttp.ClientError as e:
        raise HTTPException(status_code=503, detail=f"Unable to reach the medicine service: {str(e)}")

async def create_request(session: AsyncSession, request: CreateMedicineRequest, user: dict):
    async with aiohttp.ClientSession() as http_session:
        tasks = [_fetch_dispenser_data(request.dispenser_id, http_session),
                 _fetch_medicine_data(request.medicine_id, http_session), 
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

        # add the request to the database
        new_request = MedicineRequest(dispenser_id=dispenser['id'], medicine_id=medicine['id'], requested_by=user['id'], batch_number=request.batch_number, emergency=request.emergency)
        
        session.add(new_request)
        await session.commit()
        
        new_status = MedicineStatusChange(request_id=new_request.id)
        session.add(new_status)
        await session.commit()

        #asyncio.create_task(publish_notification_by_role('Novo medicamento solicitado!', 'Acesse o aplicativo para aceitar ou recusar.', 1, "nurse"))
        #await publish_notification_by_role('Novo medicamento solicitado!', 'Acesse o aplicativo para aceitar ou recusar.', 1, "nurse")
        return new_request

async def fetch_request(session: AsyncSession, request_id: int, user: dict):    
    async with aiohttp.ClientSession() as http_session:
        stmt = select(MedicineRequest).where(MedicineRequest.id == request_id)
        result = await session.execute(stmt)
        request_result = result.scalar()

        dispenser_task = _fetch_dispenser_data(request_result.dispenser_id, http_session)
        medicine_task = _fetch_medicine_data(request_result.medicine_id, http_session)
        requested_by_task = _fetch_user_by_id(request_result.requested_by, http_session)
        assign_to_task = _fetch_user_by_id(request_result.assign_to, http_session) if request_result.assign_to else asyncio.sleep(0)
        tasks = [dispenser_task, medicine_task, requested_by_task, assign_to_task]
        try:
            results = await asyncio.gather(*tasks, return_exceptions=True)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to fetch data: {str(e)}")

        # Check for HTTPException errors in results
        for result in results:
            if isinstance(result, HTTPException):
                raise result  # Raise the HTTPException

        # If no HTTPException, extract data from results
        dispenser, medicine, requested, assign = results

        request = {
            "id": request_result.id,
            "dispenser": dispenser,
            "item": medicine,
            "requested_by": requested,
            "status_changes": request_result.status_changes,
            "created_at": request_result.created_at,
            "batch_number": request_result.batch_number,
            "emergency": request_result.emergency,
            "feedback": request_result.feedback,
            "assign_to": assign
        }
        return request

async def fetch_last_user_request(session: AsyncSession, user: dict):
    async with aiohttp.ClientSession() as http_session:
        stmt = select(MedicineRequest).where(MedicineRequest.requested_by == user['id']).order_by(MedicineRequest.id.desc()).limit(1)
        result = await session.execute(stmt)
        request_result = result.scalar()

        dispenser_task = _fetch_dispenser_data(request_result.dispenser_id, http_session)
        medicine_task = _fetch_medicine_data(request_result.medicine_id, http_session)
        requested_by_task = _fetch_user_by_id(request_result.requested_by, http_session)
        assign_to_task = _fetch_user_by_id(request_result.assign_to, http_session) if request_result.assign_to else asyncio.sleep(0)
        tasks = [dispenser_task, medicine_task, requested_by_task, assign_to_task]
        
        try:
            results = await asyncio.gather(*tasks, return_exceptions=True)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to fetch data: {str(e)}")

        # Check for HTTPException errors in results
        for result in results:
            if isinstance(result, HTTPException):
                raise result  # Raise the HTTPException

        # If no HTTPException, extract data from results
        dispenser, medicine, requested, assign = results
        request = {
            "id": request_result.id,
            "dispenser": dispenser,
            "medicine": medicine,
            "requested_by": requested,
            "created_at": request_result.created_at,
            "batch_number": request_result.batch_number,
            "emergency": request_result.emergency,
            "feedback": request_result.feedback,
            "assign_to": assign,
            "status_changes": request_result.status_changes
        }
        return request
    
async def create_feedback(session: AsyncSession, request: CreateMedicineRequest, user: dict):     
    stmt = select(MedicineRequest).where(MedicineRequest.id == request.request_id)
    result = await session.execute(stmt)
    medicine_request = result.scalars().first()

    if not medicine_request:
        raise HTTPException(status_code=404, detail="Medicine request not found")

    # Update the feedback column
    medicine_request.feedback = request.feedback

    # Commit the changes to the database
    session.add(medicine_request)
    await session.commit()
    await session.refresh(medicine_request)

    return medicine_request

async def assign_request(session: AsyncSession, request: AssignMedicineRequest, user: dict):   
    async with aiohttp.ClientSession() as http_session:
        tasks = [_fetch_user_data(user['sub'], http_session),
                 _update_status(request.request_id, http_session)
        ]
        try:
            results = await asyncio.gather(*tasks, return_exceptions=True)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to fetch data: {str(e)}")

        # Check for HTTPException errors in results
        for result in results:
            if isinstance(result, HTTPException):
                raise result  # Raise the HTTPException
                
        # If no HTTPException, extract data from results
        agent = results  

    stmt = select(MedicineRequest).where(MedicineRequest.id == request.request_id)
    result = await session.execute(stmt)
    medicine_request = result.scalars().first()

    if not medicine_request:
        raise HTTPException(status_code=404, detail="Assistance request not found")

    # Update the feedback column
    medicine_request.assign_to = agent[0]['id']

    # Commit the changes to the database
    session.add(medicine_request)
    await session.commit()
    await session.refresh(medicine_request)

    return medicine_request


async def update_status(session: AsyncSession, request: changeStatus, user: dict, id):
    print('in service')
    stmt = select(MedicineRequest).where(MedicineRequest.id == int(id))
    result = await session.execute(stmt)
    assistance_request = result.scalars().first()

    if not assistance_request:
        raise HTTPException(status_code=404, detail="Assistance request not found")

    print(assistance_request)
    # Update the status column
    assistance_request.status = request.status

    change_status = MedicineStatusChange(request_id=int(id), status=request.status)

    session.add(change_status)
    
    # Commit the changes to the database
    session.add(assistance_request)
    await session.commit()
    return assistance_request

