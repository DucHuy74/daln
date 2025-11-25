import pandas as pd
from scipy.stats import spearmanr, pearsonr

from interface.interface import AlgorithmsStrategy

class WordSimilarity:
    def __init__(self, word2Vec):
        self.word2Vec = word2Vec
        self.load_sim353_dataset('./wordsim353/set2.csv')
        # self.load_sim353_dataset('./Wordsim353-cs/WordSim353-cs.csv')
        self.load_rg65_dataset('./EN-RG-65.txt')
            

    def load_sim353_dataset(self, filepath):
        df = pd.read_csv(filepath, sep=',')
        self.df_study_sim353 = df[['Word 1', 'Word 2', 'Human (mean)']].copy()
        self.df_study_sim353.rename(columns={'Human (mean)': 'Human_Score_Xi'}, inplace=True)
    # def load_sim353_dataset(self, filepath):
    #     df = pd.read_csv(filepath, sep=',')
    #     self.df_study_sim353 = df[['en_word_1', 'en_word_2', 'en mean']].copy()
    #     self.df_study_sim353.rename(columns={'en mean': 'Human_Score_Xi', 'en_word_1': 'Word 1', 'en_word_2': 'Word 2'}, inplace=True)

    def load_rg65_dataset(self, filepath):
        df = pd.read_csv(filepath, sep=r'\s+', names=['Word 1', 'Word 2', 'Human (mean)'])
        self.df_study_rg65 = df[['Word 1', 'Word 2', 'Human (mean)']].copy()
        self.df_study_rg65.rename(columns={'Human (mean)': 'Human_Score_Xi'}, inplace=True)

    def calculate_spearman_rho(self, X_i, Y_i):
        rho, p_value = spearmanr(X_i, Y_i)
        return rho
    
    def calculate_pearson_r(self, X_i, Y_i):
        r, p_value = pearsonr(X_i, Y_i)
        return r

    
    def run(self, strategy: AlgorithmsStrategy, beta1=None, beta2=None, bias_b=None):
        if self.df_study_sim353 is None:
            return

        algorithm_scores_Yi_Sim353 = []
        algorithm_scores_Yi_Rg65 = []

        for index, row in self.df_study_sim353.iterrows():
            w1 = row['Word 1']
            w2 = row['Word 2']

            if beta1 is not None and beta2 is not None and bias_b is not None:
                score = strategy.calculate(w1, w2, beta1=beta1, beta2=beta2, bias_b=bias_b)
            else:
                score = strategy.calculate(w1, w2)

            algorithm_scores_Yi_Sim353.append(score)

        for index, row in self.df_study_rg65.iterrows():
            w1 = row['Word 1']
            w2 = row['Word 2']

            if beta1 is not None and beta2 is not None and bias_b is not None:
                score = strategy.calculate(w1, w2, beta1=beta1, beta2=beta2, bias_b=bias_b)
            else:
                score = strategy.calculate(w1, w2)

            algorithm_scores_Yi_Rg65.append(score)


        #lấy ra 2 cột điểm để tính độ tương quan
        X_i_sim353 = self.df_study_sim353['Human_Score_Xi'] / 10.0
        X_i_rg65 = self.df_study_rg65['Human_Score_Xi'] / 4.0

        # 1. Tính Pearson (r)
        r_pearson_sim353 = self.calculate_pearson_r(X_i_sim353, algorithm_scores_Yi_Sim353)
        r_pearson_rg65 = self.calculate_pearson_r(X_i_rg65, algorithm_scores_Yi_Rg65)
        
        # 2. Tính Spearman (p/rho)
        rho_spearman_sim353 = self.calculate_spearman_rho(self.df_study_sim353['Human_Score_Xi'], algorithm_scores_Yi_Sim353)
        rho_spearman_rg65 = self.calculate_spearman_rho(self.df_study_rg65['Human_Score_Xi'], algorithm_scores_Yi_Rg65)
        return {
            "Sim353": {
                "Total_Pairs": len(self.df_study_sim353),
                "Pearson_r": r_pearson_sim353,
                "Spearman_rho": rho_spearman_sim353
            },
            "RG65": {
                "Total_Pairs": len(self.df_study_rg65),
                "Pearson_r": r_pearson_rg65,
                "Spearman_rho": rho_spearman_rg65
            }
        }

    

