from pydantic import BaseModel
import enum
from typing import Optional

class UserRegistrationRequest(BaseModel):
    email: str
    password: str
    role: str

class UserResponseModel(BaseModel):
    id: int
    email: str
    role: str
    mobile_token: Optional[str] = None

class LoginResponseModel(BaseModel):
    email: str
    access_token: str
    token_type: str
    mobile_token: Optional[str] = None
    expires_at: str
    role: str

class UserRoleEnum(enum.Enum):
    ADMIN = 'admin'
    NURSE = 'nurse'
    AGENT = 'agent'

class UserLoginRequest(BaseModel):
    email: str
    password: str
    mobile_token: Optional[str] = None