from fastapi import FastAPI, APIRouter, Depends
from routes.dispenser import router as dispenser_router
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.future import select

from database import get_session, engine, Base
import uvicorn
from models.dispenser import Dispenser

app = FastAPI()

api_router = APIRouter(prefix="/pyxis")
api_router.include_router(dispenser_router)

@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
        
@api_router.get("/heartbeat")
async def read_root():
    return {"message": "Pyxis is alive!"}

@app.get("/pyxis")
async def read_items(session: AsyncSession = Depends(get_session)):
    result = await session.execute(select(Dispenser))
    items = result.scalars().all()
    return items

app.include_router(api_router)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)
