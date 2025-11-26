from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker, Session
from constant import MYSQL_HOST, MYSQL_PASSWORD, MYSQL_USERNAME, MYSQL_PORT, MYSQL_DATABASE
from src.models.base import Base

class DatabaseManager:
    def __init__(self, database_url: str):
        self.database_url = database_url
        self.engine = None
        self.SessionLocal = None
        self._setup_database()

    def _setup_database(self):
        self.engine = create_engine(
            self.database_url,
            echo=False,  
            pool_pre_ping=True,  
            pool_recycle=3600    
        )
        self.SessionLocal = sessionmaker(
            bind=self.engine, 
            expire_on_commit=False 
        )

        Base.metadata.create_all(bind=self.engine)

    def get_session(self) -> Session:  # type: ignore
        session = self.SessionLocal()
        try:
            yield session
        finally:
            session.close()
