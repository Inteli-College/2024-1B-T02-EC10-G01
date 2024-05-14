from pydantic import BaseModel
import enum

class CreateMedicineRequest(BaseModel):
    dispenser_id: int
    medicine_id: int

class MedicineRequestSchema(BaseModel):
    id: int
    dispenser: dict
    requested_by: dict
    medicine: dict
    status: str

