import os
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, declarative_base
from sqlalchemy import text

DATABASE_URL = os.getenv("DATABASE_URL")

# Create the Async Engine
engine = create_async_engine(DATABASE_URL, echo=True)

# Session maker bound to the engine
async_session = sessionmaker(engine, class_=AsyncSession)

# Base class for models
Base = declarative_base()

async def get_session() -> AsyncSession:
    async with async_session() as session:
        # Set search path at the start of each session
        await session.execute(text("SET search_path TO pyxis"))
        try:
            yield session
        finally:
            await session.close()
