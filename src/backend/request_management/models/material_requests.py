from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean
from sqlalchemy.sql import func
from database import Base
from sqlalchemy import desc  # Import desc

class MaterialRequest(Base):
    __tablename__ = 'material_requests'
    __table_args__ = {'schema': 'requests'}

    id = Column(Integer, primary_key=True)
    dispenser_id = Column(Integer)
    requested_by = Column(Integer)
    material_id = Column(Integer)
    status = Column(String, default="pending")
    emergency = Column(Boolean, default=False)

    def to_dict(self):
        return {
            "id": self.id,
            "dispenser_id": self.dispenser_id,
            "requested_by": self.requested_by,
            "material_id": self.material_id,
            "emergency": self.emergency,
            "status": self.status
        }

