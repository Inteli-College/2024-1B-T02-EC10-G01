from fastapi import FastAPI, APIRouter
from routes.medicine_requests import router as medicine_requests_router
import uvicorn

app = FastAPI()

api_router = APIRouter(prefix="/requests")
api_router.include_router(medicine_requests_router)

@api_router.get("/heartbeat")
async def read_root():
    return {"message": "Request Management is alive!"}

app.include_router(api_router)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8002)
