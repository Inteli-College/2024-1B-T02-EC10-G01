from sqlalchemy import Column, Integer, String, ForeignKey, Table
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from database import Base  # Import Base from database module


# Association table for the many-to-many relationship between Dispenser and Medicine
dispenser_medicine_association = Table(
    'dispenser_medicine', Base.metadata,
    Column('dispenser_id', Integer, ForeignKey('pyxis.dispenser.id'), primary_key=True),
    Column('medicine_id', Integer, ForeignKey('pyxis.medicine.id'), primary_key=True),
    schema='pyxis'  # Specify the schema here
)

# Association table for the many-to-many relationship between Dispenser and Material
dispenser_material_association = Table(
    'dispenser_material', Base.metadata,
    Column('dispenser_id', Integer, ForeignKey('pyxis.dispenser.id'), primary_key=True),
    Column('material_id', Integer, ForeignKey('pyxis.material.id'), primary_key=True),
    schema='pyxis' # Specify the schema here
)

# Association table for the many-to-many relationship between Dispenser and Assistance
dispenser_assistance_association = Table(
    'dispenser_assistance', Base.metadata,
    Column('dispenser_id', Integer, ForeignKey('pyxis.dispenser.id'), primary_key=True),
    Column('assistance_id', Integer, ForeignKey('pyxis.assistance.id'), primary_key=True),
    schema='pyxis' # Specify the schema here
)

class Dispenser(Base):
    __tablename__ = 'dispenser'
    __table_args__ = {'schema': 'pyxis'}

    id = Column(Integer, primary_key=True)
    code = Column(String, unique=True, index=True)
    floor = Column(Integer)

    # Relationships - Note how we reference the association table here
    medicines = relationship("Medicine", secondary=dispenser_medicine_association, back_populates="dispensers", lazy='joined')

    materials = relationship("Material", secondary=dispenser_material_association, back_populates="dispensers", lazy='joined')

    assistances = relationship("Assistance", secondary=dispenser_assistance_association, back_populates="dispensers", lazy='joined')

    def to_dict(self):
        """Return dictionary representation of the Dispenser."""
        return {
            "id": self.id,
            "code": self.code,
            "floor": self.floor,
            "medicines": [medicine.to_dict() for medicine in self.medicines],
            "materials": [material.to_dict() for material in self.materials],
            "assistances": [assistance.to_dict() for assistance in self.assistances],
        }

class Medicine(Base):
    __tablename__ = 'medicine'
    __table_args__ = {'schema': 'pyxis'}


    id = Column(Integer, primary_key=True)
    name = Column(String, unique=True, index=True)
    dosage = Column(String)

    # Relationships - Referencing the same association table
    dispensers = relationship("Dispenser", secondary=dispenser_medicine_association, back_populates="medicines")

    def to_dict(self):
        """Return dictionary representation of the Medicine."""
        return {
            "id": self.id,
            "name": self.name,
            "dosage": self.dosage,
        }

class Material(Base):
    __tablename__ = 'material'
    __table_args__ = {'schema': 'pyxis'}

    id = Column(Integer, primary_key=True)
    name = Column(String, unique=True, index=True)
    
    dispensers = relationship("Dispenser", secondary=dispenser_material_association, back_populates="materials")

    def to_dict(self):
        """Return dictionary representation of the Material."""
        return {
            "id": self.id,
            "name": self.name,
        }
    
class Assistance(Base):
    __tablename__ = 'assistance'
    __table_args__ = {'schema': 'pyxis'}

    id = Column(Integer, primary_key=True)
    description = Column(String, unique=True, index=True)
    
    dispensers = relationship("Dispenser", secondary=dispenser_assistance_association, back_populates="assistances")

    def to_dict(self):
        """Return dictionary representation of the Assistance."""
        return {
            "id": self.id,
            "description": self.description,
        }