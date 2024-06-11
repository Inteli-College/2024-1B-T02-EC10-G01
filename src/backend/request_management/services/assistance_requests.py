from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.assistance_requests import AssistanceRequest, AssistanceStatusChange
from models.schemas import CreateAssistanceRequest
from fastapi import HTTPException
import aiohttp
import asyncio
import os
import json
from middleware import is_nurse, is_agent, is_admin
from rabbitmq import rabbitmq
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
    
async def _fetch_assistance_data(assistance_id: int, session: aiohttp.ClientSession):
    url = f"{gateway_url}/pyxis/assistances/{assistance_id}"
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
    stmt = select(AssistanceRequest)
    result = await session.execute(stmt)
    return result.scalars().all()

async def create_request(session: AsyncSession, request: CreateAssistanceRequest, user: dict):
    async with aiohttp.ClientSession() as http_session:
        tasks = [_fetch_dispenser_data(request.dispenser_id, http_session),
                  _fetch_assistance_data(request.assistance_id, http_session), _fetch_user_data(user['sub'], http_session)]
        try:
            results = await asyncio.gather(*tasks, return_exceptions=True)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to fetch data: {str(e)}")

        # Check for HTTPException errors in results
        for result in results:
            if isinstance(result, HTTPException):
                raise result  # Raise the HTTPException
                
        # If no HTTPException, extract data from results
        dispenser, assistance, user = results

        # add the request to the database
        new_request = AssistanceRequest(dispenser_id=dispenser['id'], assistance_id=assistance['id'], requested_by=user['id'])
        new_status = AssistanceStatusChange(status="pending")
        new_request.status = new_status
        session.add(new_request)
        await session.commit()
        await session.refresh(new_request)
        try:
            channel = rabbitmq.get_channel()
            exchange_name = 'material_requests'
            channel.exchange_declare(exchange=exchange_name, exchange_type='topic')
            routing_key = 'request.new'
            message = {
                'id': new_request.id,
                'dispenser_id': new_request.dispenser_id,
                'assistance_id': new_request.assistance_id,
                'requested_by': new_request.requested_by,
                'status': new_status.status,
                'created_at': new_request.created_at.isoformat(),
                'feedback': new_request.feedback,
            }
            channel.basic_publish(
                exchange=exchange_name,
                routing_key=routing_key,
                body=json.dumps(message),
                properties=pika.BasicProperties(
                    delivery_mode=2,  # make message persistent
                )
            )
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to publish message: {str(e)}")

        return new_request
    
async def create_feedback(assistance_id: int, feedback: str, session: aiohttp.ClientSession, user: dict):
    stmt = select(AssistanceRequest).where(AssistanceRequest.id == assistance_id)
    result = await session.execute(stmt)
    assistance_request = result.scalars().first()

    if not assistance_request:
        raise HTTPException(status_code=404, detail="Assistance request not found")

    # Update the feedback column
    assistance_request.feedback = feedback

    # Commit the changes to the database
    session.add(assistance_request)
    await session.commit()
    await session.refresh(assistance_request)

    return assistance_request

