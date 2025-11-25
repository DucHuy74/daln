
from fastapi import FastAPI
from constant import DATABASE_URL
from src.database import DatabaseManager
from src.utils.model_loader import load_models


app = FastAPI(title="My Project API")
db_manager = DatabaseManager(DATABASE_URL)

# Gắn router từ routes.py
# app.include_router(router)

nlp, word2Vec = load_models()

@app.get("/")
def read_root():
    return {"message": "Hello World"}


