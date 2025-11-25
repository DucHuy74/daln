from src.utils.model_loader import load_models
from constant import DATABASE_URL
from src.database import DatabaseManager

nlp = None
word2Vec = None
db_manager = None

def config():
    global nlp, word2Vec, db_manager  # thông báo muốn gán biến global
    nlp, word2Vec = load_models()     # gán giá trị
    db_manager = DatabaseManager(DATABASE_URL)