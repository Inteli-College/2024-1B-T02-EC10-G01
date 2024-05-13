from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean
from sqlalchemy.sql import func
from database import Base
from sqlalchemy import desc  # Import desc

class MedicineRequest(Base):
    __tablename__ = 'medicine_requests'
    ___table_args__ = {'schema': 'requests'}

    id = Column(Integer, primary_key=True)
    dispenser_id = Column(Integer)
    requested_by = Column(String)
    medicine_id = Column(Integer)
    dosage = Column(String)
    current_status = Column(String)

    def to_dict(self):
        return {
            "id": self.id,
            "dispenser_id": self.dispenser_id,
            "requested_by": self.requested_by,
            "medicine_id": self.medicine_id,
            "dosage": self.dosage,
            "current_status": self.current_status
        }

