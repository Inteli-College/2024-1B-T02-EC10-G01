from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.medicine_requests import MedicineRequest, MedicineStatusChange
from models.schemas import CreateMedicineRequest, MedicineRequestSchema
from fastapi import HTTPException
import aiohttp
import asyncio
import os
import json
from middleware import is_nurse, is_agent, is_admin
from rabbitmq import rabbitmq
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

async def fetch_requests(session: AsyncSession):
    stmt = select(MedicineRequest)
    result = await session.execute(stmt)
    return result.scalars().all()

async def create_request(session: AsyncSession, request: CreateMedicineRequest, user: dict):
    print('INSIDE CREATE REQUEST')
    print(request)
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
        new_status = MedicineStatusChange(status="pending")
        new_request.status_id = new_status.id
        session.add(new_request)
        await session.commit()

        # try:
        #     channel = rabbitmq.get_channel()
        #     exchange_name = 'medicine_requests'
        #     channel.exchange_declare(exchange=exchange_name, exchange_type='topic')
        #     routing_key = 'request.new'
        #     message = {
        #         'id': new_request.id,
        #         'dispenser_id': new_request.dispenser_id,
        #         'medicine_id': new_request.medicine_id,
        #         'requested_by': new_request.requested_by,
        #         'status': new_status.status,
        #         'created_at': new_request.created_at
        #     }
        #     channel.basic_publish(
        #         exchange=exchange_name,
        #         routing_key=routing_key,
        #         body=json.dumps(message),
        #         properties=pika.BasicProperties(
        #             delivery_mode=2,  # make message persistent
        #         )
        #     )
        # except Exception as e:
        #     raise HTTPException(status_code=500, detail=f"Failed to publish message: {str(e)}")
        
        #asyncio.create_task(publish_notification_by_role('Novo medicamento solicitado!', 'Acesse o aplicativo para aceitar ou recusar.', 1, "nurse"))
        #await publish_notification_by_role('Novo medicamento solicitado!', 'Acesse o aplicativo para aceitar ou recusar.', 1, "nurse")
        return new_request

async def fetch_request(session: AsyncSession, request_id: int, user: dict):    
    async with aiohttp.ClientSession() as http_session:
        print('INSIDE FETCH REQUEST')
        print(request_id)
        stmt = select(MedicineRequest).where(MedicineRequest.id == request_id)
        result = await session.execute(stmt)
        request_result = result.scalar()
        print(request_result)

        tasks = [_fetch_dispenser_data(request_result.dispenser_id, http_session),
                    _fetch_medicine_data(request_result.medicine_id, http_session), 
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
            "item": medicine,
            "requested_by": user,
            "status_id": request_result.status_id,
            "created_at": request_result.created_at,
            "batch_number": request_result.batch_number,
            "emergency": request_result.emergency
            
        }
        return request

async def fetch_last_user_request(session: AsyncSession, user: dict):
    async with aiohttp.ClientSession() as http_session:
        stmt = select(MedicineRequest).where(MedicineRequest.requested_by == user['id']).order_by(MedicineRequest.id.desc()).limit(1)
        result = await session.execute(stmt)
        request_result = result.scalar()

        tasks = [_fetch_dispenser_data(request_result.dispenser_id, http_session),
                    _fetch_medicine_data(request_result.medicine_id, http_session), 
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
            "status_id": request_result.status_id,
            "created_at": request_result.created_at,
            "batch_number": request_result.batch_number,
            "emergency": request_result.emergency
        }
        return request