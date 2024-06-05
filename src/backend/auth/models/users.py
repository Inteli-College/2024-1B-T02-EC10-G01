from sqlalchemy import Column, Integer, String, ForeignKey, Table, Enum, DateTime, func
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import ENUM
from database import Base  # Import Base from database module

role_enum = ENUM('admin', 'nurse', 'agent', name='role_enum', create_type=True, schema='auth', metadata=Base.metadata)

class User(Base):
    __tablename__ = 'users'
    __table_args__ = {'schema': 'auth'}
    
    id = Column(Integer, primary_key=True, index=True, unique=True, nullable=False, autoincrement=True)
    email = Column(String(100), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    role = Column(role_enum, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    mobile_token = Column(String(255), nullable=True)

    def to_dict(self):
        """Return dictionary representation of the User."""
        return {
            "id": self.id,
            "email": self.email,
            "role": self.role if self.role else None,  # Accessing enum value
            "password_hash": self.password_hash,
            "created_at": self.created_at.isoformat() if self.created_at else None,  # Format datetime as string
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
            "mobile_token": self.mobile_token if self.mobile_token else None
        }

