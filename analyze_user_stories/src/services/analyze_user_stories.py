

from ast import List
from src.utils import find_subject, find_verb_object, objects_frequency
from experiment.similatiryStrategies import Calc_wordnet_similarity, Calc_w2v_similarity, Calculate_nonlinear_fusion
from typing import Dict, List

from mlxtend.preprocessing import TransactionEncoder
from mlxtend.frequent_patterns import apriori, association_rules
import pandas as pd
from src.configs import nlp, word2Vec


# user_stories = [
#     "As a user, I want to create my account so that I can access my account.",
#     "As an admin, I want to manage user so that I can control access levels.",
#     "As a user, I want to buy products so that I can find items to purchase."
# ]
class AnalyzeUserStories:
    def __init__(self):
        self.nlp, self.word2Vec = nlp, word2Vec
        self.calc_wordnet_similarity = Calc_wordnet_similarity()
        self.calc_w2v_similarity = Calc_w2v_similarity(self.word2Vec)
        self.calculate_nonlinear_fusion = Calculate_nonlinear_fusion(self.word2Vec, self.calc_wordnet_similarity, self.calc_w2v_similarity)
    
    def analyze(self, user_stories: List[str]):
        svo = []

        for story in filter(str.strip, user_stories):
            subject, verb, object = "", "", ""

            doc = self.nlp(story.strip())
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

            doc_core = self.nlp(story_core)

            subject = find_subject(doc_core)
            verb, object = find_verb_object(doc_core)

            svo.append({"subject": subject, "verb": verb, "object": object})




        # phân tích tần xuất object
        frequency = objects_frequency(svo)

        # đoạn này cần sửa thành tách ra thành 1 thằng là những us bị lỗi 1 thằng là svo hoàn chỉnh
        svo_errors = [item for item in svo if not (item['subject'] and item['verb'] and item['object'])]

        #normal check: loại bỏ những thằng bị thiếu object verb hoặc subject
        svo = [item for item in svo if item['subject'] and item['verb'] and item['object']]

        similarity_results = []

        # Lặp qua từng cặp SVO
        for i in range(len(svo)):
            for j in range(i + 1, len(svo)):
                for key in ["verb", "object"]:
                    w1, w2 = svo[i][key].lower(), svo[j][key].lower()

                    sim = self.calculate_nonlinear_fusion.calculate(w1, w2, beta1=5.00, beta2=1.30, bias_b=-2.0)

                    similarity_results.append({
                        w1, w2, sim
                    })

        ## có thể chọn ra 1 độ tương đồng cố định giả sử >= 0.85 thì sẽ tự động đưa về cùng 1 từ còn dưới thì sẽ cần sự xác nhận của BA
        ## ví dụ như "create" và "add" có độ tương đồng là 0.82 thì sẽ cần BA xác nhận có nên gộp hay không và có thể đưa ra 1 list các từ gọi ý từ wordnet 
        ## tức là các từ sẽ chuẩn hóa về nếu như độ tương đồng cao
        ## và ở ngưỡng phân vân sẽ do người quyết định


    def generate_association_rules(self, user_stories: List[Dict]):

        # Gom theo user_story_id → mỗi story là 1 transaction
        # VD: User story: As an admin, I want to manage users =>["admin", "manage", "users"]
        transaction_map = {}

        
        # user_stories = [
        #     {"id": 1, "subject": "admin", "action": "create", "object": "user"},
        #     {"id": 2, "subject": "user", "action": "delete"},
        #     {"db_id": 3, "action": "update", "object": "profile"},
        # ]
        

        for us in user_stories:
            usid = us.get("id")

            if us.get("subject"):
                transaction_map[usid].append(us["subject"])
            if us.get("verb"):
                transaction_map[usid].append(us["verb"])
            if us.get("object"):
                transaction_map[usid].append(us["object"])

        transactions = list(transaction_map.values())


        # Encode transactions
        te = TransactionEncoder()
        te_ary = te.fit(transactions).transform(transactions)
        df = pd.DataFrame(te_ary, columns=te.columns_)

        # Frequent itemsets
        # Tim nhom item xh chung vs tan suat >=1%
        frequent_itemsets = apriori(df, min_support=0.01, use_colnames=True)

        # Association rules
        rules_df = association_rules(frequent_itemsets, metric="confidence", min_threshold=0.1)

        rules_output = []
        for _, row in rules_df.iterrows():
            rules_output.append({
                #Dieu kien
                "antecedents": list(row["antecedents"]), # item xh trc trong rule, vd {manage} -> {admin} ->antecedents: manage
                #Ketqua
                "consequents": list(row["consequents"]), # item xh sau trong rule, vd {manage} -> {admin} ->consequents: admin
                "support": float(row["support"]), # tỷ lệ transaction có chứa cả antecedents + consequents.
                "confidence": float(row["confidence"]), #nếu antecedents xuất hiện, xác suất consequents cũng xuất hiện
                "lift": float(row["lift"])
                # do manh cua rule. >1: co y nghia, = 1-> ko co y nghia, <1 -> antecedents can tro consequents
            })

        return transactions, rules_output





