# import numpy as np
import spacy
from typing import List
from collections import Counter
import nltk
from gensim.models import KeyedVectors
# import gensim.downloader as api
from experiment.similatiryStrategies import Calc_w2v_similarity, Calc_wordnet_similarity, Calculate_nonlinear_fusion
from utils import find_role, find_verb_object, objects_frequency



nlp = spacy.load("en_core_web_sm")
for pkg in ['wordnet', 'omw-1.4']:
    try:
        nltk.data.find(f'corpora/{pkg}')
    except LookupError:
        nltk.download(pkg)


# hãy chạy 2 dòng này trước để tải mô hình về máy và lưu lại sau đó comment lại
# word2Vec = api.load("word2vec-google-news-300")
# word2Vec.save("word2vec-google-news-300.kv")

word2Vec = KeyedVectors.load("word2vec-google-news-300.kv", mmap='r')

user_stories = [
    "As a user, I want to create my account so that I can access my account.",
    "As an admin, I want to manage user so that I can control access levels.",
    "As a user, I want to buy products so that I can find items to purchase."
]

svo = []

for story in filter(str.strip, user_stories):
    role, verb, object = "", "", ""

    doc = nlp(story.strip())
    story_core_tokens: List[str] = []
    tokens_to_exclude = {token.i for token in doc if token.dep_ == "advcl"}
    

    for token in doc:
        # Lấy ra các token thuộc mệnh đề trạng ngữ
        if token.i in tokens_to_exclude:
            for child in token.subtree:
                tokens_to_exclude.add(child.i)

    for token in doc:
        if token.i not in tokens_to_exclude:
            story_core_tokens.append(token.text_with_ws)
    
    #Phần cần quan tâm đến
    story_core = "".join(story_core_tokens).strip()

    doc_core = nlp(story_core)

    role = find_role(doc_core)
    verb, object = find_verb_object(doc_core)

    svo.append({"role": role, "verb": verb, "object": object})




# phân tích tần xuất object
frequency = objects_frequency(svo)


#normal check: loại bỏ những thằng bị thiếu object verb hoặc role
svo = [item for item in svo if item['role'] and item['verb'] and item['object']]


# tính độ tương đồng ngữ nghĩa giữa các object
# === 1️⃣ WordNet Similarity ===
similarity_results_wordnet = {
    "role": [],
    "verb": [],
    "object": []
}

# === 2️⃣ Word2Vec Similarity ===
similarity_results_w2v = {
    "role": [],
    "verb": [],
    "object": []
}

calc_wordnet_similarity = Calc_wordnet_similarity()
calc_w2v_similarity = Calc_w2v_similarity(word2Vec)
calculate_nonlinear_fusion = Calculate_nonlinear_fusion(word2Vec, calc_wordnet_similarity, calc_w2v_similarity)

# Lặp qua từng cặp SVO
for i in range(len(svo)):
    for j in range(i + 1, len(svo)):
        for key in ["role", "verb", "object"]:
            w1, w2 = svo[i][key].lower(), svo[j][key].lower()

            # WordNet
            sim_wn = calc_wordnet_similarity.calculate(w1, w2)
            if sim_wn is not None:
                similarity_results_wordnet[key].append([w1, w2, round(sim_wn, 3)])

            # Word2Vec
            sim_w2v = calc_w2v_similarity.calculate(w1, w2)
            if sim_w2v is not None:
                similarity_results_w2v[key].append([w1, w2, sim_w2v])



