from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean
from sqlalchemy.sql import func
from database import Base
from sqlalchemy import desc  # Import desc
import datetime


class MedicineRequest(Base):
    __tablename__ = "medicine_requests"
    __table_args__ = {"schema": "requests"}

    id = Column(Integer, primary_key=True)
    dispenser_id = Column(Integer)
    requested_by = Column(Integer)
    medicine_id = Column(Integer)
    emergency = Column(Boolean, default=False)
    status_id = Column(Integer, ForeignKey("requests.medicine_status.id"))
    status = relationship(
        "MedicineStatusChange", uselist=False, back_populates="request"
    )
    created_at = Column(DateTime, default=func.now())
    batch_number = Column(String, nullable=True)

    def to_dict(self):
        return {
            "id": self.id,
            "dispenser_id": self.dispenser_id,
            "requested_by": self.requested_by,
            "medicine_id": self.medicine_id,
            "emergency": self.emergency,
            "status_id": self.status_id,
            "created_at": self.created_at,
            "batch_number": self.batch_number,
        }

class MedicineStatusChange(Base):
    __tablename__ = "medicine_status"
    __table_args__ = {"schema": "requests"}

    id = Column(Integer, primary_key=True)
    status = Column(String, default="pending")
    request = relationship("MedicineRequest", uselist=False, back_populates="status")

    def to_dict(self):
        return {"id": self.id, "status": self.status}
