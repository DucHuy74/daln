
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError

class BaseRepository:
    def add(self, session: Session, instance):
        try:
            session.add(instance)
            session.commit()
            session.refresh(instance)
            return instance
        except SQLAlchemyError as e:
            session.rollback()
            raise e 
        
    def getById(self, session: Session, model, id):
        return session.query(model).get(id)
    
    def delete(self, session: Session, instance):
        try:
            session.delete(instance)
            session.commit()
        except SQLAlchemyError as e:
            session.rollback()
            raise e
        
    def update(self, session: Session, model, record_id: str, data: dict):
        try:
            instance = session.query(model).filter(model.id == record_id).first()

            for key, value in data.items():
                if hasattr(model, key):
                    setattr(instance, key, value)

            session.commit()
            session.refresh(instance)
            return instance

        except SQLAlchemyError as e:
            session.rollback()
            raise e