# Datasets

This directory contains the raw data files used throughout the analysis of quorum sensing inhibitors. It serves as the central repository for all input data prior to analysis.

## Directory Structure

The Datasets directory is organized into the following subdirectories:

```
Datasets/
├── CREST/
├── Conformer_Datasets/
├── Experimental_Results/
└── make_analysis_files.R
```

## CREST Data

The `CREST/` directory contains the aggregated outputs from Conformer-Rotamer Ensemble Sampling Tool (CREST) calculations:

- `all_rotamers_energies_crest.csv`: Energy values for all rotamers identified by CREST
- `clustered_energies.csv`: Energy values for clustered conformers
- `rmsd_all_rotamers.csv`: Root-mean-square deviation (RMSD) values for all rotamers
- `rmsd_clustered.csv`: RMSD values for clustered conformers

This data represents the computational chemistry foundation for identifying the most relevant conformers for further analysis.

## Conformer Datasets

The `Conformer_Datasets/` directory contains processed data files for each of the nine conformers (0-8) that were identified as most relevant:

- `conformer_0.csv` through `conformer_8.csv`: Each file contains molecular descriptors and properties calculated for the corresponding conformer across all compounds

These files serve as the primary input for the machine learning models used in activity prediction.

## Experimental Results

The `Experimental_Results/` directory contains the experimental biological data for compounds tested against each receptor:

- `Outputs_LasR.csv`: Experimental inhibition data for compounds tested against LasR
- `Outputs_LuxR.csv`: Experimental inhibition data for compounds tested against LuxR
- `Outputs_TraR.csv`: Experimental inhibition data for compounds tested against TraR

These files contain the ground truth data that was used to train and validate the predictive models.

## Data Processing Script

The file `make_analysis_files.R` is an R script that processes the raw data files to generate the analysis-ready datasets used in the model development. This script:

1. Merges conformer data with experimental results
2. Performs necessary data transformations
3. Creates separate files for classification and regression analyses
4. Filters data according to a user-defined threshold on a column of choice

## Usage

To regenerate the analysis files from raw data:

1. Ensure all raw data files are in their respective directories
2. Run the `make_analysis_files.R` script in R or RStudio
3. Use the functions to generate the necessary files in the appropriate analysis directories:
4. Place all conformer_#.csv files in a new directory - For example, using TraR's activity
5. place the Outputs_TraR.csv file in the same directory
6. Run:
```
make_analysis_files(outputs_file = 'Outputs_TraR.csv', match_pattern = 'conformer_')
filter_datasets_by_threshold(pattern = "conformer_[0-9]+_TraR\\.csv", column_name = 'output', threshold = 15)
```

