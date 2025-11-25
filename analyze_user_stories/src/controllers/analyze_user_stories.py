from src.services.analyze_user_stories import AnalyzeUserStories

def analyze_user_stories(data):
    print(data)
    return AnalyzeUserStories().analyze(data)