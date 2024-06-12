from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum
from database import Base
from models.schemas import Status

class MedicineRequest(Base):
    __tablename__ = "medicine_requests"
    __table_args__ = {"schema": "requests"}

    id = Column(Integer, primary_key=True)
    dispenser_id = Column(Integer)
    requested_by = Column(Integer)
    medicine_id = Column(Integer)
    emergency = Column(Boolean, default=False)
    created_at = Column(DateTime, default=func.now())
    batch_number = Column(String, nullable=True)
    feedback = Column(String, default="No feedback available.")
    status = Column(String, default=Status.pending.value)

    # Define a one-to-many relationship with selectin loading
    status_changes = relationship(
        "MedicineStatusChange",
        back_populates="request",
        lazy="selectin",
        foreign_keys="[MedicineStatusChange.request_id]"
    )
    
    def to_dict(self):
        return {
            "id": self.id,
            "dispenser": self.dispenser_id,
            "requested_by": self.requested_by,
            "medicine": self.medicine_id,
            "status_changes": [status_change.to_dict() for status_change in self.status_changes],
            "emergency": self.emergency,
            "batch_number": self.batch_number,
            "created_at": self.created_at,
            "feedback": self.feedback,
            "status": self.status
        }

class MedicineStatusChange(Base):
    __tablename__ = "medicine_status_changes"
    __table_args__ = {"schema": "requests"}

    id = Column(Integer, primary_key=True)
    status = Column(String, default=Status.pending.value)
    created_at = Column(DateTime, default=func.now())
    request_id = Column(Integer, ForeignKey("requests.medicine_requests.id"))

    # Define a many-to-one relationship with remote_side set to identify the parent's primary key
    request = relationship(
        "MedicineRequest",
        back_populates="status_changes",
        foreign_keys=[request_id],
        lazy="selectin",
        remote_side=[MedicineRequest.id]
    )
    
    def to_dict(self):
        return {
            "id": self.id,
            "status": self.status,
            "created_at": self.created_at
        }
