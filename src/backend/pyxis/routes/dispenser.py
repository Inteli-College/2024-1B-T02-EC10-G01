from fastapi import APIRouter

router = APIRouter(prefix="/dispenser")

@router.get("/")
async def read_root():
    return {"message": "Dispensers!"}