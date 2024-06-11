from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.medicine_requests import MedicineStatusChange
from models.assistance_requests import AssistanceStatusChange
from models.material_requests import MaterialStatusChange
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

with open("./services/token.json", "r") as file:
    token = json.load(file)["token"]


async def update_assistance_status(session: AsyncSession, request: UpdateStatus):
    stmt = select(AssistanceStatusChange).where(AssistanceStatusChange.id == request.id)
    try:
        result = await session.execute(stmt)
        status_change = result.scalar_one()
        status_change.status = request.status
        await session.commit()
        return status_change
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Failed to publish message: {str(e)}"
        )


async def update_material_status(session: AsyncSession, request: UpdateStatus):
    stmt = select(MaterialStatusChange).where(MaterialStatusChange.id == request.id)
    try:
        result = await session.execute(stmt)
        status_change = result.scalar_one()
        status_change.status = request.status
        await session.commit()
        return status_change
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Failed to publish message: {str(e)}"
        )


async def update_medicine_status(session: AsyncSession, request: UpdateStatus):
    stmt = select(MedicineStatusChange).where(MedicineStatusChange.id == request.id)
    try:
        result = await session.execute(stmt)
        status_change = result.scalar_one()
        status_change.status = request.status
        await session.commit()
        return status_change
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Failed to publish message: {str(e)}"
        )


async def _fetch_status(status_id: int, type: str, session: AsyncSession):
    if type == "medicine":
        stmt = select(MedicineStatusChange).where(MedicineStatusChange.id == status_id)
    elif type == "material":
        stmt = select(MaterialStatusChange).where(MaterialStatusChange.id == status_id)
    elif type == "assistance":
        stmt = select(AssistanceStatusChange).where(
            AssistanceStatusChange.id == status_id
        )
    else:
        raise HTTPException(status_code=400, detail="Invalid type")
    try:
        result = await session.execute(stmt)
        status = result.scalar_one()
        return status
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch status: {str(e)}")
