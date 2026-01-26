import numpy as np
from experiment import Calc_wordnet_similarity, Calc_w2v_similarity, Calculate_nonlinear_fusion
from src.utils.model_loader import load_models
from experiment import WordSimilarity, RunExperiment

if __name__ == "__main__":
    nlp, word2Vec = load_models()

    calcWordnetSimilarity = Calc_wordnet_similarity()
    calcW2vSimilarity = Calc_w2v_similarity(word2Vec)
    calcNonlinearFusion = Calculate_nonlinear_fusion(word2Vec, calcWordnetSimilarity, calcW2vSimilarity)


    # tìm ra tham số tối ưu cho cách tiếp cận của chúng ta
    beta1_space = np.arange(1.5, 2.1, 0.1)
    beta2_space = np.arange(4.5, 5.1, 0.1)
    bias_b_space = np.arange(-3, -1, 0.1)

    run_experiment = RunExperiment(word2Vec, calcNonlinearFusion)
    run_experiment.excute(beta1_space, beta2_space, bias_b_space)


    # nếu muốn gọi những cách khác và chỉ đơn thuần đo độ tương đồng thì chỉ cần gọi đến measure
    # class WordSimilarity
    word_similarity = WordSimilarity(word2Vec)
    print(word_similarity.run(calcWordnetSimilarity))




