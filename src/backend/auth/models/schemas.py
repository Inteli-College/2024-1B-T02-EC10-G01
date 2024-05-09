from pydantic import BaseModel
import enum

class UserRegistrationRequest(BaseModel):
    email: str
    password: str
    role: str

class UserResponseModel(BaseModel):
    id: int
    email: str
    role: str

class UserRoleEnum(enum.Enum):
    ADMIN = 'admin'
    NURSE = 'nurse'
    AGENT = 'agent'