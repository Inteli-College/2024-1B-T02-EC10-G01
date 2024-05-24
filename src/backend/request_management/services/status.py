from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.medicine_requests import MedicineRequest, StatusChange
from models.schemas import CreateMedicineRequest, MedicineRequestSchema, UpdateStatus
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

async def update_status(session: AsyncSession, request: UpdateStatus):
    stmt = select(StatusChange).where(StatusChange.id == request.id)
    try:
        result = await session.execute(stmt)
        status_change = result.scalar_one()
        status_change.status = request.status
        await session.commit()
        return status_change
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to publish message: {str(e)}")
        