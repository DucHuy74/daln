#Strategy pattern
from experiment.gridSearch import GridSearchConfig
from experiment.measureSimilarity import WordSimilarity
from experiment.similatiryStrategies import Calc_w2v_similarity, Calc_wordnet_similarity, Calculate_assm, Calculate_nonlinear_fusion, Calculate_with_adaptive_weighting

class RunExperiment:
    def __init__(self, word2Vec):
        self.calc_wordnet_similarity = Calc_wordnet_similarity()
        self.calc_w2v_similarity = Calc_w2v_similarity(word2Vec)
        self.calculate_assm = Calculate_assm(word2Vec, self.calc_wordnet_similarity, self.calc_w2v_similarity)
        self.calculate_with_adaptive_weighting = Calculate_with_adaptive_weighting(word2Vec, self.calc_wordnet_similarity, self.calc_w2v_similarity)
        self.calculate_nonlinear_fusion = Calculate_nonlinear_fusion(word2Vec, self.calc_wordnet_similarity, self.calc_w2v_similarity)
        # Word Similarity Evaluation
        self.wordSimilarity = WordSimilarity(word2Vec)

    def excute(self):
        # result_W2V_method = wordSimilarity.run(calc_w2v_similarity)

        # result_assm_method = wordSimilarity.run(calculate_assm)

        # result_wordnet_method = wordSimilarity.run(calc_wordnet_similarity)

        # result_adapting_weighting_method = wordSimilarity.run(calculate_with_adaptive_weighting)


        gridSearchConfig = GridSearchConfig(self.wordSimilarity, self.calculate_nonlinear_fusion)

        gridSearchConfig.parallel_grid_search()
        # print_similarity_results("Word2Vec method",wordSimilarity.run(calculate_nonlinear_fusion))


