from fastapi import FastAPI, APIRouter, Depends
from routes.dispenser import router as dispenser_router
from routes.medicine import router as medicine_router
from routes.material import router as material_router
from routes.assistance import router as assistance_router
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.future import select
from middleware import is_admin, is_nurse, is_agent, get_current_user

from database import get_session, engine, Base
import uvicorn
from models.dispenser import Dispenser

app = FastAPI()

api_router = APIRouter(prefix="/pyxis")
api_router.include_router(dispenser_router)
api_router.include_router(medicine_router)
api_router.include_router(material_router)
api_router.include_router(assistance_router)


@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
        
@api_router.get("/heartbeat")
async def read_root(user: dict = Depends(is_admin)):
    return {"message": "Pyxis is alive!"}

app.include_router(api_router)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)
