from experiment import RunExperiment, Calc_wordnet_similarity, Calc_w2v_similarity, Calculate_nonlinear_fusion
from src.utils.model_loader import load_models


if __name__ == "__main__":
    nlp, word2Vec = load_models()

    calcWordnetSimilarity = Calc_wordnet_similarity()
    calcW2vSimilarity = Calc_w2v_similarity(word2Vec)
    calcNonlinearFusion = Calculate_nonlinear_fusion(word2Vec, calcWordnetSimilarity, calcW2vSimilarity)


    # tìm ra tham số tối ưu cho cách tiếp cận của chúng ta
    run_experiment = RunExperiment(word2Vec, calcNonlinearFusion)
    run_experiment.excute()


    # nếu muốn gọi những cách khác và chỉ đơn thuần đo độ tương đồng thì chỉ cần gọi đến measure
    # class WordSimilarity





    # wordSimilarity = WordSimilarity(word2Vec)
    # wordSimilarity.test_datasets()
