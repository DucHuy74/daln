import pandas as pd
from scipy.stats import spearmanr, pearsonr
import json
from interface.interface import AlgorithmsStrategy

class WordSimilarity:
    def __init__(self, word2Vec):
        self.word2Vec = word2Vec
        self.load_sim353_dataset('./experiment/dataset/wordsim353/combined.csv')
        # self.load_sim353_dataset('./Wordsim353-cs/WordSim353-cs.csv')
        self.load_rg65_dataset('./experiment/dataset/EN-RG-65.txt')
        self.load_mc30_dataset('./experiment/dataset/mc30.json')
        self.load_simlex999_dataset('./experiment/dataset/SimLex-999/SimLex-999.txt')
        

    def load_sim353_dataset(self, filepath):
        df = pd.read_csv(filepath, sep=',')
        self.df_study_sim353 = df[['Word 1', 'Word 2', 'Human (mean)']].copy()
        self.df_study_sim353.rename(columns={'Human (mean)': 'Human_Score_Xi'}, inplace=True)
    def load_rg65_dataset(self, filepath):
        df = pd.read_csv(filepath, sep=r'\s+', names=['Word 1', 'Word 2', 'Human (mean)'])
        self.df_study_rg65 = df[['Word 1', 'Word 2', 'Human (mean)']].copy()
        self.df_study_rg65.rename(columns={'Human (mean)': 'Human_Score_Xi'}, inplace=True)
    def load_mc30_dataset(self, filepath):
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)
        dataset = [(item.get("term1"), item.get("term2"), item.get("value")) for item in data]
        df = pd.DataFrame(dataset, columns=['Word 1', 'Word 2', 'Human_Score_Xi'])
        self.df_study_mc30 = df.copy()
    def load_simlex999_dataset(self, filepath):
        df = pd.read_csv(filepath, sep='\t', header=0)
        df = df[['word1', 'word2', 'SimLex999']].copy()
        df.rename(columns={'SimLex999': 'Human_Score_Xi'}, inplace=True)
        # lưu vào biến của class
        self.df_study_simlex999 = df

    def test_datasets(self):
        print("Sim353 Dataset:")
        print(self.df_study_sim353.head())
        print("\nRG65 Dataset:")
        print(self.df_study_rg65.head())
        print("\nMC30 Dataset:")
        print(self.df_study_mc30.head())
        print("\nSimLex999 Dataset:")
        print(self.df_study_simlex999.head())
    
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
        algorithm_scores_Yi_Mc30 = []
        algorithm_scores_Yi_Simlex999 = []

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
            
        for index, row in self.df_study_mc30.iterrows():
            w1 = row['Word 1']
            w2 = row['Word 2']

            if beta1 is not None and beta2 is not None and bias_b is not None:
                score = strategy.calculate(w1, w2, beta1=beta1, beta2=beta2, bias_b=bias_b)
            else:
                score = strategy.calculate(w1, w2)

            algorithm_scores_Yi_Mc30.append(score)

        for index, row in self.df_study_simlex999.iterrows():
            w1 = row['word1']
            w2 = row['word2']

            if beta1 is not None and beta2 is not None and bias_b is not None:
                score = strategy.calculate(w1, w2, beta1=beta1, beta2=beta2, bias_b=bias_b)
            else:
                score = strategy.calculate(w1, w2)

            algorithm_scores_Yi_Simlex999.append(score)

        

        #lấy ra 2 cột điểm để tính độ tương quan
        X_i_sim353 = self.df_study_sim353['Human_Score_Xi'] / 10.0
        X_i_rg65 = self.df_study_rg65['Human_Score_Xi'] / 4.0
        X_i_mc30 = self.df_study_mc30['Human_Score_Xi'] / 4.0
        x_i_simlex999 = self.df_study_simlex999['Human_Score_Xi'] / 10.0

        # 1. Tính Pearson (r)
        r_pearson_sim353 = self.calculate_pearson_r(X_i_sim353, algorithm_scores_Yi_Sim353)
        r_pearson_rg65 = self.calculate_pearson_r(X_i_rg65, algorithm_scores_Yi_Rg65)
        r_pearson_mc30 = self.calculate_pearson_r(X_i_mc30, algorithm_scores_Yi_Mc30)
        r_pearson_simlex999 = self.calculate_pearson_r(x_i_simlex999, algorithm_scores_Yi_Simlex999)
        # 2. Tính Spearman (p/rho)
        rho_spearman_sim353 = self.calculate_spearman_rho(self.df_study_sim353['Human_Score_Xi'], algorithm_scores_Yi_Sim353)
        rho_spearman_rg65 = self.calculate_spearman_rho(self.df_study_rg65['Human_Score_Xi'], algorithm_scores_Yi_Rg65)
        rho_spearman_mc30 = self.calculate_spearman_rho(self.df_study_mc30['Human_Score_Xi'], algorithm_scores_Yi_Mc30)
        rho_spearman_simlex999 = self.calculate_spearman_rho(self.df_study_simlex999['Human_Score_Xi'], algorithm_scores_Yi_Simlex999)

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
            },
            "MC30": {
                "Total_Pairs": len(self.df_study_mc30),
                "Pearson_r": r_pearson_mc30,
                "Spearman_rho": rho_spearman_mc30
            },
            "SimLex999": {
                "Total_Pairs": len(self.df_study_simlex999),
                "Pearson_r": r_pearson_simlex999,
                "Spearman_rho": rho_spearman_simlex999
            }
        }

    

