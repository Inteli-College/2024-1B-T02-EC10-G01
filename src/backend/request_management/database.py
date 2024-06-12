import os
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, DeclarativeBase
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncAttrs


DATABASE_URL = os.getenv("DATABASE_URL")

# Create the Async Engine
engine = create_async_engine(DATABASE_URL, echo=True, pool_recycle=1800, pool_pre_ping=True,  # Test connections before using them
  )

# Session maker bound to the engine
async_session = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

class Base(AsyncAttrs, DeclarativeBase):
    pass

async def get_session() -> AsyncSession:
    async with async_session() as session:
        await session.execute(text("SET search_path TO requests"))
        try:
            yield session
        finally:
            await session.close()
