from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from models.dispenser import Dispenser
import json
import qrcode
from io import BytesIO
import asyncio
from concurrent.futures import ThreadPoolExecutor

async def fetch_dispensers(session: AsyncSession):
    stmt = select(Dispenser).options(selectinload(Dispenser.medicines))
    result = await session.execute(stmt)
    return result.scalars().all()

async def fetch_dispenser_by_id(session: AsyncSession, dispenser_id: int):
    stmt = select(Dispenser).filter(Dispenser.id == dispenser_id)
    result = await session.execute(stmt)
    return result.scalar()

def _sync_generate_qr_code(data: dict):
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(json.dumps(data))
    qr.make(fit=True)
    img = qr.make_image(fill='black', back_color='white')
    img_byte_array = BytesIO()
    img.save(img_byte_array, format="PNG")
    img_byte_array.seek(0)
    return img_byte_array

async def generate_qr_code(data: dict):
    loop = asyncio.get_running_loop()
    with ThreadPoolExecutor() as pool:
        img_byte_array = await loop.run_in_executor(pool, _sync_generate_qr_code, data)
        return img_byte_array
