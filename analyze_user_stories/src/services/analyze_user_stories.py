

from ast import List
from analyze_user_stories.src.utils import find_role, find_verb_object, objects_frequency
from analyze_user_stories.experiment.similatiryStrategies import Calc_wordnet_similarity, Calc_w2v_similarity, Calculate_nonlinear_fusion

# user_stories = [
#     "As a user, I want to create my account so that I can access my account.",
#     "As an admin, I want to manage user so that I can control access levels.",
#     "As a user, I want to buy products so that I can find items to purchase."
# ]
class analyze_user_stories:
    def __init__(self, nlp, word2Vec):
        self.nlp, self.word2Vec = nlp, word2Vec
        self.calc_wordnet_similarity = Calc_wordnet_similarity()
        self.calc_w2v_similarity = Calc_w2v_similarity(self.word2Vec)
        self.calculate_nonlinear_fusion = Calculate_nonlinear_fusion(self.word2Vec, self.calc_wordnet_similarity, self.calc_w2v_similarity)
    


    def analyze(self, user_stories: List[str]):
        svo = []

        for story in filter(str.strip, user_stories):
            role, verb, object = "", "", ""

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

            role = find_role(doc_core)
            verb, object = find_verb_object(doc_core)

            svo.append({"role": role, "verb": verb, "object": object})




        # phân tích tần xuất object
        frequency = objects_frequency(svo)



        # đoạn này cần sửa thành tách ra thành 1 thằng là những us bị lỗi 1 thằng là svo hoàn chỉnh
        svo_errors = [item for item in svo if not (item['role'] and item['verb'] and item['object'])]

        #normal check: loại bỏ những thằng bị thiếu object verb hoặc role
        svo = [item for item in svo if item['role'] and item['verb'] and item['object']]

        
        
        # Lặp qua từng cặp SVO
        for i in range(len(svo)):
            for j in range(i + 1, len(svo)):
                for key in ["role", "verb", "object"]:
                    w1, w2 = svo[i][key].lower(), svo[j][key].lower()

                    sim = self.calculate_nonlinear_fusion.calculate(w1, w2, beta1=5.00, beta2=1.30, bias_b=-2.0)




