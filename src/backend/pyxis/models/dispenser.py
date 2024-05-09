from sqlalchemy import Column, Integer, String, ForeignKey, Table
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from database import Base  # Import Base from database module


# Association table for the many-to-many relationship between Dispenser and Medicine
dispenser_medicine_association = Table(
    'dispenser_medicine', Base.metadata,
    Column('dispenser_id', Integer, ForeignKey('dispenser.id'), primary_key=True),
    Column('medicine_id', Integer, ForeignKey('medicine.id'), primary_key=True)
)

class Dispenser(Base):
    __tablename__ = 'dispenser'

    id = Column(Integer, primary_key=True)
    code = Column(String, unique=True, index=True)
    floor = Column(Integer)

    # Relationships - Note how we reference the association table here
    medicines = relationship("Medicine", secondary=dispenser_medicine_association, back_populates="dispensers")

class Medicine(Base):
    __tablename__ = 'medicine'

    id = Column(Integer, primary_key=True)
    name = Column(String, unique=True, index=True)
    dosage = Column(String)

    # Relationships - Referencing the same association table
    dispensers = relationship("Dispenser", secondary=dispenser_medicine_association, back_populates="medicines")

class Material(Base):
    __tablename__ = 'material'

    id = Column(Integer, primary_key=True)
    name = Column(String, unique=True, index=True)
    # Add any relationships or additional fields as necessary
