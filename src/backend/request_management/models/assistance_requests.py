from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean
from sqlalchemy.sql import func
from database import Base
from sqlalchemy import desc  # Import desc
import datetime

class AssistanceRequest(Base):
    __tablename__ = 'assistance_requests'
    __table_args__ = {'schema': 'requests'}

    id = Column(Integer, primary_key=True)
    dispenser_id = Column(Integer)
    requested_by = Column(Integer)
    assistance_id = Column(Integer)
    status_id = Column(Integer, ForeignKey('requests.assistance_status.id'))
    status = relationship("AssistanceStatusChange", uselist=False, back_populates="request")
    created_at = Column(DateTime, default=datetime.datetime.now())
    feedback = Column(String, default="Nenhum feedback disponível.")

    def to_dict(self):
        return {
            "id": self.id,
            "dispenser_id": self.dispenser_id,
            "requested_by": self.requested_by,
            "assistance_id": self.assistance_id,
            "status_id": self.status_id,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "feedback": self.feedback
        }

class AssistanceStatusChange(Base):
    __tablename__ = 'assistance_status'
    __table_args__ = {'schema': 'requests'}

    id = Column(Integer, primary_key=True)
    status = Column(String, default="pending")
    request = relationship("AssistanceRequest", uselist=False ,back_populates="status")

    def to_dict(self):
        return {
            "id": self.id,
            "status": self.status
        }
    
