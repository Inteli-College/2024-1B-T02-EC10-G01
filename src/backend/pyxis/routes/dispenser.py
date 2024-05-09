from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from database import get_session, engine, Base
from models.dispenser import Dispenser
import json
import qrcode
from io import BytesIO
from fastapi.responses import StreamingResponse


router = APIRouter(prefix="/dispensers")

@router.get("/")
async def read_dispensers(session: AsyncSession = Depends(get_session)):
    # Create a statement to select dispensers and load medicines with selectinload
    stmt = select(Dispenser).options(selectinload(Dispenser.medicines))
    result = await session.execute(stmt)
    dispensers = result.scalars().all()
    return {
        "dispensers": [
            {
                "id": dispenser.id,
                "code": dispenser.code,
                "floor": dispenser.floor,
                "medicines": [
                    {"id": medicine.id, "name": medicine.name, "dosage": medicine.dosage}
                    for medicine in dispenser.medicines
                ]
            }
            for dispenser in dispensers
        ]
    }


@router.get("/{dispenser_id}/qr")
async def get_dispenser_qr(dispenser_id: int, session: AsyncSession = Depends(get_session)):
    # Fetch the dispenser by ID
    stmt = select(Dispenser).filter(Dispenser.id == dispenser_id)
    result = await session.execute(stmt)
    dispenser = result.scalar()

    if not dispenser:
        raise HTTPException(status_code=404, detail="Dispenser not found")

    # Generate QR code
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(json.dumps({
        "dispenser_id": dispenser.id,
        "code": dispenser.code,
        "floor": dispenser.floor,
    }))
    qr.make(fit=True)

    img = qr.make_image(fill='black', back_color='white')

    # Convert the image to a streamable response
    img_byte_array = BytesIO()
    img.save(img_byte_array, format="PNG")
    img_byte_array.seek(0)

    return StreamingResponse(img_byte_array, media_type="image/png")
