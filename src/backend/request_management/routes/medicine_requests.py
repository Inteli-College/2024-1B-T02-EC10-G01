from fastapi import APIRouter

router = APIRouter(prefix="/medicines")

@router.get("/")
async def read_root():
    return {"message": "Medicine requests!"}