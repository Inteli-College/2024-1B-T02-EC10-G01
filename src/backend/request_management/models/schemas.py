from pydantic import BaseModel
import enum

class CreateMedicineRequest(BaseModel):
    dispenser_id: int
    medicine_id: int
    emergency: bool
    created_at: str

class MedicineRequestSchema(BaseModel):
    id: int
    dispenser: dict
    requested_by: dict
    medicine: dict
    status: str
    emergency: bool

class CreateMaterialRequest(BaseModel):
    dispenser_id: int
    material_id: int

class MaterialRequestSchema(BaseModel):
    id: int
    dispenser: dict
    requested_by: dict
    material: dict
    status: str

class CreateAssistanceRequest(BaseModel):
    dispenser_id: int
    assistance_id: int
    created_at: str

class AssistanceRequestSchema(BaseModel):
    id: int
    dispenser: dict
    requested_by: dict
    assistance: dict
    status: str

class UpdateStatus(BaseModel):
    id: int
    status: str
