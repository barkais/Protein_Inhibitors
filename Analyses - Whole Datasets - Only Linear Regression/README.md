# Analyses - Whole Datasets - Only Linear Regression

This directory contains the full dataset analyses using linear regression models for the three quorum sensing receptors (LasR, LuxR, and TraR). Unlike the main analyses directory, these analyses do not filter compounds based on activity thresholds and use only linear regression approaches.

## Directory Structure

The directory is organized by receptor, with each containing source data, analysis scripts, and results:

```
Analyses - Whole Datasets - Only Linear Regression/
├── LasR/
│   ├── Regression_results/
│   ├── LasR_Regression.Rmd
│   └── conformer_X_LasR.csv files
├── LuxR/
│   ├── Regression_Results/
│   ├── LuxR_regression.Rmd
│   └── conformer_X_LuxR.csv files
└── TraR/
    ├── Regression_Results/
    ├── TraR_regression.Rmd
    └── conformer_X_TraR.csv files
```

## Data Files

Each receptor directory contains:

- `conformer_X_RECEPTOR.csv`: Complete datasets for each conformer (0-8) without activity filtering
- R Markdown files for regression analysis (e.g., `LasR_Regression.Rmd`)

## Results Directories

The `Regression_results/` directories within each receptor folder contain:

- **Model summary files**: CSV files with top models (e.g., `LasR_top_models_4_4_LO_5.csv`)
- **Visualization plots**: PNG files showing regression performance (e.g., `LasR_reg_4_4_LO_5.png`)
- **Out-of-sample predictions**: CSV files with validation predictions (e.g., `OOS_predictions.csv`)
- **Model evaluation outputs**: Text files summarizing model performance (e.g., `output_model_evaluation_LasR.txt`)

### Conformer-Specific Model Directories

Each regression results directory also includes subdirectories for individual conformer models:

- Named with pattern: `conformer_X_RECEPTOR_minY_maxZ_TIMESTAMP/`
- Each contains:
  - `models_list.csv`: List of models evaluated
  - `predictions.csv`: Prediction results for that specific conformer
