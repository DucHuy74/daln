from fastapi import FastAPI
from constant import DATABASE_URL
from src.routes.analyze import router
from src.database  import DatabaseManager
app = FastAPI(title="My Project API")

# Gắn router từ routes.py
app.include_router(router, prefix="/api")
DatabaseManager(DATABASE_URL)

@app.get("/")
def read_root():
    return {"message": "Hello World"}


