from nltk.corpus import wordnet as wn
import numpy as np

from interface.interface import AlgorithmsStrategy


class Calc_wordnet_similarity(AlgorithmsStrategy):
    def __init__(self):
        pass
    
    def calculate(self, w1, w2):
        syn1 = wn.synsets(w1)
        syn2 = wn.synsets(w2)
        if not syn1 or not syn2:
            return 0.0 
        
        max_sim = 0.0 # Bắt đầu bằng 0.0
        for s1 in syn1:
            for s2 in syn2:
                sim = s1.wup_similarity(s2)
                # Chỉ cập nhật nếu sim tồn tại (không None) và lớn hơn max hiện tại
                if sim and sim > max_sim:
                    max_sim = sim
        return max_sim


class Calc_w2v_similarity(AlgorithmsStrategy):
    def __init__(self, word2Vec):
        self.word2Vec = word2Vec

    def calculate(self, w1, w2):
        if w1 not in self.word2Vec or w2 not in self.word2Vec:
            return 0.0
        
        return self.word2Vec.similarity(w1, w2)

class Calculate_assm(AlgorithmsStrategy):
    def __init__(self, word2Vec_model, calc_wordnet_similarity: Calc_wordnet_similarity, calc_w2v_similarity: Calc_w2v_similarity):
        self.word2Vec_model = word2Vec_model
        self.calc_w2v_similarity = calc_w2v_similarity
        self.calc_wordnet_similarity = calc_wordnet_similarity

    def calculate(self, w1, w2):
        Sim_W2V = self.calc_w2v_similarity.calculate(w1, w2)
        
        Sim_WP = self.calc_wordnet_similarity.calculate(w1, w2)
        
        if Sim_W2V == 0.0 and Sim_WP == 0.0:
            return 0.0

        alpha = (Sim_WP + Sim_W2V) / 2.0
        
    
        if alpha > 1.0: alpha = 1.0
        if alpha < 0.0: alpha = 0.0
    
        beta = (alpha * Sim_WP) + ((1.0 - alpha) * Sim_W2V)

        ASSM_score = max(Sim_W2V, beta)
        
        return ASSM_score

class Calculate_with_adaptive_weighting(AlgorithmsStrategy):
    def __init__(self, word2Vec, calc_wordnet_similarity: Calc_wordnet_similarity, calc_w2v_similarity: Calc_w2v_similarity):
        self.word2Vec = word2Vec
        self.calc_w2v_similarity = calc_w2v_similarity
        self.calc_wordnet_similarity = calc_wordnet_similarity
    
    def calculate(self, w1, w2):
    # alpha = 0.7 nếu 2 từ có trong wordnet và 0.9 nếu 1 trong 2 không cso trong wordnet và 1 nếu không có trong wordnet
        syn1 = wn.synsets(w1)
        syn2 = wn.synsets(w2)

        alpha = 0.7
        if not syn1 or not syn2:
            # print(f"One of the words '{w1}' or '{w2}' is not in WordNet.")
            alpha = 0.9
        if not syn1 and not syn2:
            # print(f"Both words '{w1}' and '{w2}' are not in WordNet.")
            alpha = 1.0

        return alpha * self.calc_w2v_similarity.calculate(w1, w2) + (1 - alpha) * self.calc_wordnet_similarity.calculate(w1, w2)

class Calculate_nonlinear_fusion(AlgorithmsStrategy):

    def __init__(self, word2Vec_model, calc_wordnet_similarity: Calc_wordnet_similarity, calc_w2v_similarity: Calc_w2v_similarity):
        self.word2Vec_model = word2Vec_model
        self.calc_w2v_similarity = calc_w2v_similarity
        self.calc_wordnet_similarity = calc_wordnet_similarity

    def sigmoid(self, x):
        return 1.0 / (1.0 + np.exp(-x))

    def calculate(self, w1, w2, beta1=None, beta2=None, bias_b=None):
    
        # Huownsg chọn B1 b2 và b sao cho phù hợp
        # tìm kiếm lưới sao cho đọ tương đồng gần với đánh giá của con người nhất
        # sim thuộc 0-> 1 và B
        sim_w2v = self.calc_w2v_similarity.calculate(w1, w2)
        sim_wn = self.calc_wordnet_similarity.calculate(w1, w2)

        sim_w2v = float(sim_w2v)
        sim_wn = float(sim_wn)
        
        x = (beta1 * sim_w2v) + (beta2 * sim_wn) + bias_b

        sim_total = self.sigmoid(x)

        return sim_total

