from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean
from sqlalchemy.sql import func
from database import Base
from sqlalchemy import desc  # Import desc
import datetime
from models.schemas import Status


class MaterialRequest(Base):
    __tablename__ = 'material_requests'
    __table_args__ = {'schema': 'requests'}

    id = Column(Integer, primary_key=True)
    dispenser_id = Column(Integer)
    requested_by = Column(Integer)
    material_id = Column(Integer)
    created_at = Column(DateTime, default=func.now())
    feedback = Column(String, default="Nenhum feedback disponível.")
    status = Column(String, default=Status.pending.value)
    
     # Define a one-to-many relationship with selectin loading
    status_changes = relationship(
        "MaterialStatusChange",
        back_populates="request",
        lazy="selectin",
        foreign_keys="[MaterialStatusChange.request_id]"
    )

    def to_dict(self):
        return {
            "id": self.id,
            "dispenser_id": self.dispenser_id,
            "requested_by": self.requested_by,
            "material_id": self.material_id,
            "status_changes": [status_change.to_dict() for status_change in self.status_changes],
            "created_at": self.created_at,
            "feedback": self.feedback,
            "status": self.status
        }
class MaterialStatusChange(Base):
    __tablename__ = 'material_status_change'
    __table_args__ = {'schema': 'requests'}

    id = Column(Integer, primary_key=True)
    status = Column(String, default=Status.pending.value)
    created_at = Column(DateTime, default=func.now())
    request_id = Column(Integer, ForeignKey("requests.material_requests.id"))

    # Define a many-to-one relationship with remote_side set to identify the parent's primary key
    request = relationship(
        "MaterialRequest",
        back_populates="status_changes",
        foreign_keys=[request_id],
        lazy="selectin",
        remote_side=[MaterialRequest.id]
    )
    
    def to_dict(self):
        return {
            "id": self.id,
            "status": self.status,
            "created_at": self.created_at
        }