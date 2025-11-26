from fastapi import FastAPI
from src.routes.analyze import router

app = FastAPI(title="My Project API")

# Gắn router từ routes.py
app.include_router(router, prefix="/api")

@app.get("/")
def read_root():
    return {"message": "Hello World"}


