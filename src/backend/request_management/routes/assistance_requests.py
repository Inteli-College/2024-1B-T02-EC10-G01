from fastapi import APIRouter
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.schemas import CreateAssistanceRequest
from middleware import get_current_user, is_admin, is_nurse, is_agent
from services.assistance_requests import fetch_requests, create_request

router = APIRouter(prefix="/assistance")

@router.get("/")
async def read_assistance_requests(session: AsyncSession = Depends(get_session), user: dict = Depends(get_current_user)):
    requests = await fetch_requests(session)
    return [request.to_dict() for request in requests]

@router.post("/")
async def create_assistance_request(request: CreateAssistanceRequest, session: AsyncSession = Depends(get_session), user: dict = Depends(is_nurse)):
    created_request = await create_request(session, request, user)
    return created_request