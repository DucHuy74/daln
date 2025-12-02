from experiment import RunExperiment
from src.utils.model_loader import load_models

if __name__ == "__main__":
    nlp, word2Vec = load_models()
    run_experiment = RunExperiment(word2Vec)
    run_experiment.excute()