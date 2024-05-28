from fastapi import FastAPI, APIRouter
from routes.medicine_requests import router as medicine_requests_router
from routes.material_requests import router as material_requests_router
from routes.material_requests import router as assistance_requests_router
from routes.status import router as status_router
import uvicorn
from database import get_session, engine, Base
from models.medicine_requests import MedicineRequest, StatusChange
from models.material_requests import MaterialRequest
from models.assistance_requests import AssistanceRequest

app = FastAPI()

api_router = APIRouter(prefix="/requests")
api_router.include_router(medicine_requests_router)
api_router.include_router(material_requests_router)
api_router.include_router(assistance_requests_router)
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
