
from typing import List
from fastapi import FastAPI
from src.utils.model_loader import load_models
app = FastAPI(title="My Project API")

# Gắn router từ routes.py
# app.include_router(router)

nlp, word2Vec = load_models()

@app.get("/")
def read_root():
    return {"message": "Hello World"}


