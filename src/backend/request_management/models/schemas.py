from pydantic import BaseModel
import enum
from typing import Optional

class CreateMedicineRequest(BaseModel):
    dispenser_id: int
    medicine_id: int
    emergency: bool
    batch_number: Optional[str] = None

class MedicineRequestSchema(BaseModel):
    id: int
    dispenser: dict
    requested_by: dict
    medicine: dict
    status: str
    emergency: bool
    batch_number: str = None
    created_at: str
    feedback: str

class CreateMaterialRequest(BaseModel):
    dispenser_id: int
    material_id: int

class MaterialRequestSchema(BaseModel):
    id: int
    dispenser: dict
    requested_by: dict
    material: dict
    status: str
    feedback: str

class CreateAssistanceRequest(BaseModel):
    dispenser_id: int
    assistance_id: int

class AssistanceRequestSchema(BaseModel):
    id: int
    dispenser: dict
    requested_by: dict
    assistance: dict
    status: str
    created_at: str
    feedback: str

class UpdateStatus(BaseModel):
    id: int
    status: str
