from sqlalchemy import Column, Integer, String, ForeignKey, Table, Enum, DateTime, func
from sqlalchemy.orm import relationship
from database import Base  # Import Base from database module

class User(Base):
    __tablename__ = 'users'
    __table_args__ = {'schema': 'auth'}
    
    id = Column(Integer, primary_key=True)
    email = Column(String(100), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    role = Column(Enum('admin', 'nurse', 'agent', name='role'), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
