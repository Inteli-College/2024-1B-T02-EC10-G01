from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean
from sqlalchemy.sql import func
from database import Base
from sqlalchemy import desc
import datetime
import enum


class AssistanceStatus(enum.Enum):
    pending = "pending"
    accepted = "accepted"
    rejected = "rejected"
    resolved = "resolved"


class AssistanceRequest(Base):
    __tablename__ = "assistance_requests"
    __table_args__ = {"schema": "requests"}

    id = Column(Integer, primary_key=True)
    dispenser_id = Column(Integer)
    requested_by = Column(Integer)
    assistance_type = Column(String)
    details = Column(String, nullable=True)
    created_at = Column(DateTime, default=func.now())
    feedback = Column(String, default="Nenhum feedback disponível.")
    status = Column(String, default=AssistanceStatus.pending.value)
    assign_to = Column(Integer)

    status_changes = relationship(
        "AssistanceStatusChange",
        back_populates="request",
        lazy="selectin",
        foreign_keys="[AssistanceStatusChange.request_id]",
    )

    def to_dict(self):
        return {
            "id": self.id,
            "dispenser": self.dispenser_id,
            "requested_by": self.requested_by,
            "assistance_type": self.assistance_type,
            "status_changes": [status.to_dict() for status in self.status_changes],
            "details": self.details,
            "created_at": self.created_at,
            "feedback": self.feedback,
            "status": self.status,
            "assign_to": self.assign_to
        }


class AssistanceStatusChange(Base):
    __tablename__ = "assistance_status_change"
    __table_args__ = {"schema": "requests"}

    id = Column(Integer, primary_key=True)
    status = Column(String, default=AssistanceStatus.pending.value)
    created_at = Column(DateTime, default=func.now())
    request_id = Column(Integer, ForeignKey("requests.assistance_requests.id"))

    request = relationship(
        "AssistanceRequest",
        back_populates="status_changes",
        foreign_keys=[request_id],
        lazy="selectin",
        remote_side=[AssistanceRequest.id],
    )

    def to_dict(self):
        return {
            "id": self.id,
            "status": self.status,
            "created_at": self.created_at,
        }
