from fastapi import FastAPI, APIRouter
from routes.dispenser import router as dispenser_router
import uvicorn

app = FastAPI()

api_router = APIRouter(prefix="/pyxis")
api_router.include_router(dispenser_router)

@api_router.get("/heartbeat")
async def read_root():
    return {"message": "Pyxis is alive!"}

app.include_router(api_router)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)
