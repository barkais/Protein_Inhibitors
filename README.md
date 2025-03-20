# Quorum Sensing Inhibitor Analysis

> Computational analysis of quorum sensing inhibitors against LasR, LuxR, and TraR receptors

## Project Overview

This repository contains computational analyses of quorum sensing (QS) inhibitors targeting three bacterial transcription factors: LasR, LuxR, and TraR. The project uses various computational chemistry techniques to understand structure-activity relationships and predict compound activity.

## Directory Structure

The repository is organized into the following main directories:

- **Analyses - Code and Data**: Contains R scripts and source data files for classification and regression models for each receptor - Use to completely reproduce analyses
- **Analyses - Published Results**: Contains published model outputs, visualizations, and validated results - Analyses results as they were published in the study
- **Analyses - Whole Datasets - Only Linear Regression**: Contains full dataset analysis using only linear regression models, for comparison and motivation for the pre-classification step 
- **Datasets**: Contains raw data files including CREST conformer data, experimental results, and preprocessing scripts
- **xyz**: Contains molecular structure files in XYZ format, organized by conformer families - compressed to a single .zip file

## Getting Started

First, install the needed packages

```
install.packages(c(
  # Package Installer
  "remotes",      # For installing non-CRAN packages
  
  # Core packages
  "parallel",     # For parallel processing
  "ggplot2",      # For visualization
  
  # Data manipulation
  "data.table",   # For efficient data reading/writing
  "dplyr",        # For data transformations
  "tibble",       # For enhanced data frames
  "reshape2",     # For reshaping data
  
  # Utilities
  "stringr",      # For string manipulation
  "default",      # For setting default parameters
  "knitr",        # For table rendering
  "ggrepel",      # For non-overlapping text labels
  
  # Statistical/ML packages
  "nnet",         # For neural network models
  "MASS",         # For statistical models
))

#
# Once `remotes` is properly installed, use the `install_github` function to install `rxn.con.class` and `moleculaR`.
# Then, load the packages.

# Install
remotes::install_github('https://github.com/barkais/rxn.cond.class.git')
remotes::install_github('https://github.com/barkais/moleculaR.git')
```


## Citation

If you use this data in your research, please cite:

[Citation information]

## Contact

[Contact information]
