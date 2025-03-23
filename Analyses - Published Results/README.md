# Analyses - Published Results

This directory contains the final results and outputs from the quorum sensing inhibitor analyses, organized by receptor. These are the validated, polished results intended for publication and reference.

## Directory Structure

The directory is organized by receptor, with each receptor having separate subdirectories for classification and regression results:

```
Analyses - Published Results/
├── LasR/
│   ├── Classification_Results/
│   └── Regression_Results/
├── LuxR/
│   ├── Classification_results/
│   └── Regression_Results/
|── TraR/
|   ├── Classification_Results/
|   └── Regression_Results/
|── Datasets/
└── Reproduce_Results.Rmd

```

## Classification Results

Each receptor's classification results directory contains:

- **Validation set results** (e.g., `Class_validation_set_results_LasR.csv`): Performance metrics for models on validation data
- **Visualization plots** (e.g., `LasR_Classification_results.png`): Visual representation of classification performance
- **Model specifications** (e.g., `LasR_class_models.csv`): Details of the best-performing classification models

## Regression Results

The regression results directories contain more detailed output structures:

- **Top model selections** (e.g., `LasR_above_15_top_models_4_4_LO_5.csv`): Best-performing regression models
- **Out-of-sample predictions** (e.g., `OOS_predictions.csv`): Model predictions for validation compounds
- **Visualization plots** (e.g., `LasR_reg_4_4_LO_5.png`): Graphical representations of model performance
- **Model evaluation summaries** (e.g., `output_model_evaluation_TraR.txt`): Detailed performance metrics

### Conformer-Specific Model Directories

Each regression results directory includes subdirectories for individual conformer models:

- Named with pattern: `conformer_X_RECEPTOR_above_15_minY_maxZ_TIMESTAMP/`
- Each contains:
  - `models_list.csv`: List of models evaluated
  - `predictions.csv`: Prediction results for that specific conformer

## Datasets

For each receptor, the following types of data files are available:

- `conformer_X_RECEPTOR_class.csv`: Classification dataset of the published model
- `conformer_X_RECEPTOR_above_15.csv`: Regression dataset of the published model

### Reproduce_Results.Rmd

An R notebook for the exact reproduction of puslished results. Should be run after downloading all files in this directory. 
