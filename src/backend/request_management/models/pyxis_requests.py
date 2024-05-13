from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean
from sqlalchemy.sql import func
from database import Base
from sqlalchemy import desc  # Import desc


class Request(Base):
    __tablename__ = 'requests'
    __table_args__ = {'schema': 'requests'}
    id = Column(Integer, primary_key=True)
    type = Column(String(50), nullable=False)
    status = Column(String) 
    pyxis_id = Column(Integer)
    requested_by = Column(Integer)
    feedback = Column(String)
    __mapper_args__ = {
        'polymorphic_identity': 'request',
        'polymorphic_on': type,
        'with_polymorphic': '*'
    }
    status_updates = relationship('StatusUpdate', back_populates='request', order_by=desc('StatusUpdate.updated_at'))


class StatusUpdate(Base):
    __tablename__ = 'status_updates'
    __table_args__ = {'schema': 'requests'}

    id = Column(Integer, primary_key=True)
    request_id = Column(Integer, ForeignKey('requests.requests.id'))
    request_type = Column(String, nullable=False)
    old_status = Column(String)
    new_status = Column(String)
    updated_at = Column(DateTime(timezone=True), default=func.now())
    updated_by = Column(String)

    request = relationship('Request', back_populates='status_updates')

    def to_dict(self):
        return {
            "id": self.id,
            "request_id": self.request_id,
            "request_type": self.request_type,
            "old_status": self.old_status,
            "new_status": self.new_status,
            "updated_at": self.updated_at.isoformat(),
            "updated_by": self.updated_by
        }


class MedicineRequest(Request):
    __tablename__ = 'medicine_requests'
    __table_args__ = {'schema': 'requests'}
    id = Column(Integer, ForeignKey('requests.requests.id'), primary_key=True)
    medicine = Column(String)
    dosage = Column(String)
    is_emergency = Column(Boolean)
    __mapper_args__ = {
        'polymorphic_identity': 'medicine_request',
    }

class MaterialRequest(Request):
    __tablename__ = 'material_requests'
    __table_args__ = {'schema': 'requests'}
    id = Column(Integer, ForeignKey('requests.requests.id'), primary_key=True)
    material = Column(String)
    is_emergency = Column(Boolean)
    __mapper_args__ = {
        'polymorphic_identity': 'material_request',
    }

class AssistanceRequest(Request):
    __tablename__ = 'assistance_requests'
    __table_args__ = {'schema': 'requests'}
    id = Column(Integer, ForeignKey('requests.requests.id'), primary_key=True)
    issue = Column(String)
    description = Column(String)
    __mapper_args__ = {
        'polymorphic_identity': 'assistance_request',
    }
