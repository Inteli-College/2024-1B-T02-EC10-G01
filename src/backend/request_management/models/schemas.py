from pydantic import BaseModel
import enum
from typing import Optional

class CreateMedicineRequest(BaseModel):
    dispenser_id: int
    medicine_id: int
    emergency: bool
    batch_number: Optional[str] = None

class CreateMedicineFeedback(BaseModel):
    request_id: int
    feedback: str

class AssignMedicineRequest(BaseModel):
    request_id: int

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
    assign_to: dict

class CreateMaterialRequest(BaseModel):
    dispenser_id: int
    material_id: int

class CreateMaterialFeedback(BaseModel):
    request_id: int
    feedback: str

class AssignMaterialRequest(BaseModel):
    request_id: int

class MaterialRequestSchema(BaseModel):
    id: int
    dispenser: dict
    requested_by: dict
    material: dict
    status: str
    feedback: str
    assign_to: dict

class CreateAssistanceRequest(BaseModel):
    dispenser_id: int
    assistance_type: str
    details: str

class CreateAssistanceFeedback(BaseModel):
    request_id: int
    feedback: str

class AssignAssistanceRequest(BaseModel):
    request_id: int

class changeStatus(BaseModel):
    status: str

class AssistanceRequestSchema(BaseModel):
    id: int
    dispenser: dict
    requested_by: dict
    assistance: dict
    status: str
    created_at: str
    feedback: str
    assign_to: dict

class UpdateStatus(BaseModel):
    id: int
    status: str
    
class Status(enum.Enum):
    pending = 'pending'
    accepted = 'accepted'
    rejected = 'rejected'
    completed = 'completed'
    preparing = 'preparing'
    inTransit = 'inTransit'

