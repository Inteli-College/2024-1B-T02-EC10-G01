from fastapi import FastAPI, APIRouter
from routes.medicine_requests import router as medicine_requests_router
import uvicorn
from database import get_session, engine, Base
from routes.medicine_requests import router as medicine_requests_router
from models.medicine_requests import MedicineRequest, StatusChange
from routes.status import router as status_router

app = FastAPI()

api_router = APIRouter(prefix="/requests")
api_router.include_router(medicine_requests_router)
api_router.include_router(status_router)

@app.on_event("startup")
async def startup():
    print("Starting up and creating tables...")
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    print("Tables created.")

@api_router.get("/heartbeat")
async def read_root():
    return {"message": "Request Management is alive!"}

app.include_router(api_router)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8002)
