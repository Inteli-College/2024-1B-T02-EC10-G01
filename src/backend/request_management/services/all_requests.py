from sqlalchemy import union_all, literal
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.medicine_requests import MedicineRequest, MedicineStatusChange
from models.material_requests import MaterialRequest, MaterialStatusChange
from models.assistance_requests import AssistanceRequest, AssistanceStatusChange
from fastapi import HTTPException
import aiohttp
import asyncio
import os
import json

gateway_url = os.getenv("GATEWAY_URL", "http://localhost:8000")

with open("./services/token.json", "r") as file:
    token = json.load(file)["token"]

async def _fetch_data(endpoint: str, id: int, session: aiohttp.ClientSession):
    url = f"{gateway_url}/{endpoint}/{id}"
    headers = {"Authorization": f"Bearer {token}"}
    try:
        async with session.get(url, headers=headers) as response:
            if response.status == 200:
                return await response.json()
            else:
                error_message = await response.text()
                raise HTTPException(status_code=response.status, detail=error_message)
    except aiohttp.ClientError as e:
        raise HTTPException(
            status_code=503, detail=f"Unable to reach the service: {str(e)}"
        )

async def _fetch_status_changes(request_id: int, type: str, session: AsyncSession):
    model_map = {
        "medicine": MedicineStatusChange,
        "material": MaterialStatusChange,
        "assistance": AssistanceStatusChange
    }
    stmt = select(model_map[type]).filter(model_map[type].request_id == request_id)
    result = await session.execute(stmt)
    return result.scalars().all()

async def fetch_request_data(request_dict, session: aiohttp.ClientSession, db_session: AsyncSession, user_email: str):
    request_type = request_dict["request_type"]
    dispenser_data_task = _fetch_data("pyxis/dispensers", request_dict["dispenser_id"], session) if request_dict.get("dispenser_id") else asyncio.sleep(0)
    item_data_task = _fetch_data(f"pyxis/{request_type}s", request_dict.get(f"medicine_id"), session) if request_type in ["medicine", "material"] else asyncio.sleep(0)
    user_data_task = _fetch_data("auth/users", user_email, session)
    assign_to_task = _fetch_data("auth/users", request_dict.get(f"assign_to"), session) if request_dict.get("assign_to") else asyncio.sleep(0)
    status_changes_task = _fetch_status_changes(request_dict["id"], request_type, db_session)
    
    tasks = [dispenser_data_task, item_data_task, user_data_task, assign_to_task, status_changes_task]
    results = await asyncio.gather(*tasks, return_exceptions=True)
    for result in results:
        if isinstance(result, HTTPException):
            raise result

    return {
        "dispenser": results[0],
        "item": results[1],
        "requested_by": results[2],
        "assign_to": results[3],
        "status_changes": results[4],
        **request_dict
    }

async def fetch_latest_request(session: AsyncSession, user: dict):
    async with aiohttp.ClientSession() as http_session:
        medicine_query = select_requests(MedicineRequest, user_id=user["id"], request_type="medicine")
        material_query = select_requests(MaterialRequest, user_id=user["id"], request_type="material")
        assistance_query = select_requests(AssistanceRequest, user_id=user["id"], request_type="assistance")
        
        union_query = union_all(medicine_query, material_query, assistance_query).alias("combined_requests")
        stmt = select(union_query).order_by(union_query.c.created_at.desc()).limit(1)

        result = await session.execute(stmt)
        request_result = result.fetchone()
                
        if not request_result:
            raise HTTPException(status_code=404, detail="No requests found")

        request_dict = prepare_request_dict(request_result)
        request = await fetch_request_data(request_dict, http_session, session, user["sub"])

        return request

async def fetch_all_requests_by_user(session: AsyncSession, user: dict):
    async with aiohttp.ClientSession() as http_session:
        medicine_query = select_requests(MedicineRequest, user_id=user["id"], request_type="medicine")
        material_query = select_requests(MaterialRequest, user_id=user["id"], request_type="material")
        assistance_query = select_requests(AssistanceRequest, user_id=user["id"], request_type="assistance")

        union_query = union_all(medicine_query, material_query, assistance_query).alias("combined_requests")
        stmt = select(union_query).order_by(union_query.c.created_at.desc())

        result = await session.execute(stmt)
        request_results = result.fetchall()
                
        if not request_results:
            raise HTTPException(status_code=404, detail="No requests found")
        grouped_requests = {}
        for row in request_results:
            request_dict = prepare_request_dict(row)
            request = await fetch_request_data(request_dict, http_session, session, user["sub"])
            if request["status"] not in grouped_requests:
                grouped_requests[request["status"]] = [request]
            else:
                grouped_requests[request["status"]].append(request)

        return grouped_requests

async def fetch_pending_requests(session: AsyncSession, user: dict):
    async with aiohttp.ClientSession() as http_session:
        medicine_query = select_requests(MedicineRequest,request_type="medicine")
        material_query = select_requests(MaterialRequest, request_type="material")
        assistance_query = select_requests(AssistanceRequest,request_type="assistance")

        union_query = union_all(medicine_query, material_query, assistance_query).alias("combined_requests")
        stmt = select(union_query).order_by(union_query.c.created_at.desc())

        result = await session.execute(stmt)
        request_results = result.fetchall()
        if not request_results:
            raise HTTPException(status_code=404, detail="No requests found")

        requests = {"requests": []}
        for row in request_results:
            request_dict = prepare_request_dict(row)
            request = await fetch_request_data(request_dict, http_session, session, user["sub"])
            requests["requests"].append(request)

        return requests


def select_requests(model, user_id=None, status=None, request_type=None):
    query = select(
        model.id,
        model.dispenser_id,
        model.medicine_id if request_type == "medicine" else model.material_id if request_type == "material" else literal(None).label("material_id"),
        literal(None).label("assistance_type") if request_type in ["medicine", "material"] else model.assistance_type,
        literal(None).label("details") if request_type in ["medicine", "material"] else model.details,
        model.created_at,
        model.batch_number if request_type == "medicine" else literal(None).label("batch_number"),
        model.emergency if request_type == "medicine" else literal(None).label("emergency"),
        literal(request_type).label("request_type"),
        model.status
    )
    if user_id:
        query = query.where(model.requested_by == user_id)
    if status:
        query = query.where(model.status == status)
    return query

def prepare_request_dict(request_result):
    return {
        "id": request_result[0],
        "dispenser_id": request_result[1],
        "medicine_id": request_result[2],
        "assistance_type": request_result[3],
        "details": request_result[4],
        "created_at": request_result[5],
        "batch_number": request_result[6],
        "emergency": request_result[7],
        "request_type": request_result[8],
        "status": request_result[9]
    }
