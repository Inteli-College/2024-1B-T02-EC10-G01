from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean
from sqlalchemy.sql import func
from database import Base
from sqlalchemy import desc  # Import desc
import datetime

class MaterialRequest(Base):
    __tablename__ = 'material_requests'
    __table_args__ = {'schema': 'requests'}

    id = Column(Integer, primary_key=True)
    dispenser_id = Column(Integer)
    requested_by = Column(Integer)
    material_id = Column(Integer)
    status_id = Column(Integer, ForeignKey('requests.material_status.id'))
    status = relationship("MaterialStatusChange", uselist=False, back_populates="request")
    created_at = Column(DateTime, default=datetime.datetime.now())
    feedback = Column(String, default="Nenhum feedback disponível.")

    def to_dict(self):
        return {
            "id": self.id,
            "dispenser_id": self.dispenser_id,
            "requested_by": self.requested_by,
            "material_id": self.material_id,
            "status_id": self.status_id,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "feedback": self.feedback
        }

class MaterialStatusChange(Base):
    __tablename__ = 'material_status'
    __table_args__ = {'schema': 'requests'}

    id = Column(Integer, primary_key=True)
    status = Column(String, default="pending")
    request = relationship("MaterialRequest", uselist=False ,back_populates="status")

    def to_dict(self):
        return {
            "id": self.id,
            "status": self.status
        }