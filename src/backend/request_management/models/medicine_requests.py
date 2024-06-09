from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean
from sqlalchemy.sql import func
from database import Base
from sqlalchemy import desc  # Import desc

class MedicineRequest(Base):
    __tablename__ = 'medicine_requests'
    __table_args__ = {'schema': 'requests'}

    id = Column(Integer, primary_key=True)
    dispenser_id = Column(Integer)
    requested_by = Column(Integer)
    medicine_id = Column(Integer)
    status_id = Column(Integer, ForeignKey('requests.medicine_status.id'))
    emergency = Column(Boolean, default=False)
    status = relationship("MedicineStatusChange", uselist=False, back_populates="request")
    created_at = Column(DateTime(timezone=True), server_default=func.now())


    def to_dict(self):
        return {
            "id": self.id,
            "dispenser_id": self.dispenser_id,
            "requested_by": self.requested_by,
            "medicine_id": self.medicine_id,
            "emergency": self.emergency,
            "status_id": self.status_id,
            "created_at": self.created_at.isoformat()
        }
    
class MedicineStatusChange(Base):
    __tablename__ = 'medicine_status'
    __table_args__ = {'schema': 'requests'}

    id = Column(Integer, primary_key=True)
    status = Column(String, default="pending")
    request = relationship("MedicineRequest", uselist=False ,back_populates="status")

    def to_dict(self):
        return {
            "id": self.id,
            "status": self.status
        }

