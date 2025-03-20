# Analyses - Code and Data

This directory contains the R scripts and datasets used for classification and regression analyses of quorum sensing inhibitors against three bacterial receptors: LasR, LuxR, and TraR.

## Directory Structure

The directory is organized by receptor, with separate subdirectories for LasR, LuxR, and TraR:

```
Analyses - Code and Data/
├── LasR/
├── LuxR/
└── TraR/
```

Each receptor directory contains:

- R Markdown files (.Rmd) for classification and regression analyses
- CSV files for different conformers with appropriate data preprocessing

## Data Files

For each receptor, the following types of data files are available:

- `conformer_X_RECEPTOR_class.csv`: Classification datasets for each conformer (0-8) with binary activity labels
- `conformer_X_RECEPTOR_above_15.csv`: Regression datasets for each conformer (0-8) with activity values for compounds above threshold

## Analysis Scripts

Two primary analysis scripts are available for each receptor:

1. **Classification Analysis**: (e.g., `LasR_Classification.Rmd`)
   - Binary classification (active/inactive)
   - Feature selection
   - Model training and validation
   - Performance metrics

2. **Regression Analysis**: (e.g., `LasR_Regression.Rmd`)
   - Quantitative prediction of inhibition activity
   - Feature selection
   - Model training and validation
   - Performance metrics

## Usage

To run the analyses:

1. Open the R Markdown files in RStudio
2. Ensure all required packages are installed 
3. Run the analysis chunks sequentially
4. The scripts will generate models and output files that will be saved to the same directory

## Required R Packages

The analysis scripts require several R packages, including:

- `data.table` for data manipulation
- `dplyr` for data transformations
- `ggplot2` for visualization
- `caret` for machine learning
- `nnet` for neural network models
- `MASS` for statistical models
- Additional custom functions defined in scripts

## Note

These scripts assume specific directory structures and file naming conventions. Modifying file names or locations may require adjustments to the scripts.
