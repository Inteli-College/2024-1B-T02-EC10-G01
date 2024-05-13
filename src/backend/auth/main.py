from fastapi import FastAPI, APIRouter, Depends
from routes.auth import router as auth_router
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.future import select
from database import get_session, engine, Base
import uvicorn
import logging

logging.basicConfig()    
logging.getLogger("sqlalchemy.engine").setLevel(logging.DEBUG)

app = FastAPI()

api_router = APIRouter(prefix="/auth")
api_router.include_router(auth_router)

@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

app.include_router(api_router)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8003)