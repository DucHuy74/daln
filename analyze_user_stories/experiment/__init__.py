#Strategy pattern
from interface.interface import AlgorithmsStrategy
from experiment.gridSearch import GridSearchConfig
from experiment.measureSimilarity import WordSimilarity
from experiment.similatiryStrategies import Calc_w2v_similarity, Calc_wordnet_similarity, Calculate_assm, Calculate_nonlinear_fusion, Calculate_with_adaptive_weighting

class RunExperiment:
    def __init__(self, word2Vec, algorithms: AlgorithmsStrategy):
        self.calc_wordnet_similarity = Calc_wordnet_similarity()
        # Word Similarity Evaluation
        self.wordSimilarity = WordSimilarity(word2Vec)
        self.algorithms = algorithms # đây là thuật toán sử dụng để tính toán độ tương đồng

    def excute(self):
        gridSearchConfig = GridSearchConfig(self.wordSimilarity, self.algorithms)

        gridSearchConfig.parallel_grid_search()
        # print_similarity_results("Word2Vec method",wordSimilarity.run(calculate_nonlinear_fusion))
