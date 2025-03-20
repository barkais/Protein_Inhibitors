### Package Management
# 
# This section loads all required packages for data processing functions
# and installs any missing packages automatically.

# Function to check if packages are installed and install them if needed
check_and_install_packages <- function(package_list) {
  for (package in package_list) {
    if (!requireNamespace(package, quietly = TRUE)) {
      message(paste("Installing package:", package))
      install.packages(package, dependencies = TRUE)
    }
    library(package, character.only = TRUE)
  }
}

# List of required packages
required_packages <- c(
  "data.table",  # For efficient data manipulation and file I/O
  "tools"        # For file path manipulation functions
)

# Check and load all required packages
check_and_install_packages(required_packages)

### Description 
# This script provides utility functions for processing chemical conformer data files
# and filtering datasets based on thresholds. 
#
# Key functions:
# - make_analysis_files: Creates analysis-ready files by combining conformer data with outputs
# - filter_datasets_by_threshold: Filters datasets based on numeric thresholds
# 
### Author - Shahar Barkai

### Create Analysis Files from Conformer Data
# 
### Description
# This function creates analysis-ready files by combining conformer data with output variables.
# It processes multiple conformer files that match a given pattern and combines them with 
# a single outputs file containing response variables like 'output' and 'class'.
# 
# For each matching conformer file, two new files are created:
# 1. A file with the 'output' column added (for regression analysis)
# 2. A file with 'flag' and 'class' columns added (for classification analysis)
#
### param outputs_file Path to the CSV file containing output values (format: "Outputs_<case>.csv")
### param match_pattern Regex pattern to match conformer files (e.g., "conformer_.*\\.csv")
#
### return Logical value indicating whether the operation was successful
#
### Examples
### Process files for a specific case
# make_analysis_files("Outputs_inhibition.csv", "conformer_.*\\.csv")

make_analysis_files <- function(outputs_file, match_pattern) {
  # Load required library
  if (!requireNamespace("data.table", quietly = TRUE)) {
    install.packages("data.table")
    library(data.table)
  } else {
    library(data.table)
  }
  
  # Check if outputs file exists
  if (!file.exists(outputs_file)) {
    cat("Error: Outputs file not found:", outputs_file, "\n")
    return(FALSE)
  }
  
  # Extract case name from outputs file (assuming format is "Outputs_<case>.csv")
  # This will be used in the output filenames
  case <- gsub("Outputs_|\\.csv", "", outputs_file)
  
  # Read the outputs file with original column names preserved
  # We use check.names=FALSE to maintain the exact original column names
  outputs_data <- data.table::fread(outputs_file, check.names = FALSE)
  
  # Get the list of conformer files matching the pattern in the current directory
  conformer_files <- list.files(pattern = match_pattern)
  
  if (length(conformer_files) == 0) {
    cat("Warning: No files found matching pattern:", match_pattern, "\n")
    return(FALSE)
  }
  
  cat("Found", length(conformer_files), "files matching pattern:", match_pattern, "\n")
  
  # Process each conformer file
  for (conf_file in conformer_files) {
    # Extract conformer number from filename (assuming format includes "conformer_<num>")
    # This extracts the numeric identifier for the conformer
    conformer_num <- gsub(".*conformer_([0-9]+).*", "\\1", conf_file)
    
    # Read the conformer file with original column names preserved
    conformer_data <- data.table::fread(conf_file, check.names = FALSE)
    
    # Verify that the number of rows matches between conformer and outputs files
    # This is a basic data integrity check
    if (nrow(conformer_data) != nrow(outputs_data)) {
      cat("Warning: Row count mismatch between", conf_file, "and", outputs_file, "\n")
      cat("  Conformer rows:", nrow(conformer_data), "Outputs rows:", nrow(outputs_data), "\n")
      next  # Skip this file and move to the next one
    }
    
    # Verify ID matching if "Unnamed: 0" exists in both files
    # This checks that the row order is the same in both files
    if ("Unnamed: 0" %in% colnames(conformer_data) && "Unnamed: 0" %in% colnames(outputs_data)) {
      if (!all(conformer_data[["Unnamed: 0"]] == outputs_data[["Unnamed: 0"]])) {
        cat("Warning: ID mismatch between", conf_file, "and", outputs_file, "\n")
        next  # Skip this file and move to the next one
      }
    }
    
    # 1. Create file with output column added (for regression analysis)
    # We use copy() to avoid modifying the original data
    conformer_with_output <- copy(conformer_data)
    conformer_with_output$output <- outputs_data$output
    
    # Create a filename for the conformer with output
    output_filename <- paste0("conformer_", conformer_num, "_", case, ".csv")
    
    # Save the conformer with output, preserving exact column names
    data.table::fwrite(conformer_with_output, output_filename)
    
    # 2. Create file with flag and class columns added (for classification analysis)
    conformer_with_class <- copy(conformer_data)
    all_columns <- names(conformer_with_class)
    
    # Generate sequential row numbers for flag column (important for tracking samples)
    flag_column <- 1:nrow(conformer_with_class)
    
    # Convert to data.table to manipulate column order
    conformer_with_class <- as.data.table(conformer_with_class)
    
    # Ensure flag is the second column (after ID column)
    if (length(all_columns) >= 1) {
      # Get the first column name (usually ID or Unnamed: 0)
      first_col <- all_columns[1]
      
      # Remove first column temporarily
      first_col_data <- conformer_with_class[[first_col]]
      conformer_with_class[, (first_col) := NULL]
      
      # Add columns back in correct order: ID, flag, [other columns]
      conformer_with_class <- data.table(
        placeholder = first_col_data,
        flag = flag_column,
        conformer_with_class
      )
      setnames(conformer_with_class, "placeholder", first_col)
    } else {
      # If there are no columns, just create with dummy first col and flag
      # This is a fallback that should rarely occur
      conformer_with_class <- data.table(
        dummy_first_col = rep(NA, length(flag_column)),
        flag = flag_column
      )
    }
    
    # Add the class column from the outputs file
    conformer_with_class$class <- outputs_data$class
    
    # Create a filename for the conformer with class
    class_filename <- paste0("conformer_", conformer_num, "_", case, "_class.csv")
    
    # Save the conformer with flag and class, preserving exact column names
    data.table::fwrite(conformer_with_class, class_filename)
    
    cat("Processed file:", conf_file, "-> created", output_filename, "and", class_filename, "\n")
  }
  
  cat("Completed processing", length(conformer_files), "files for outputs file:", outputs_file, "\n")
  return(TRUE)
}

### Filter Datasets by Threshold Value
### Description
# This function filters datasets based on a threshold value for a specific column.
# It processes multiple files matching a given pattern and creates new files containing
# only the rows where the specified column's value exceeds the threshold.
#
#
### param pattern Regex pattern to match files to process
### param column_name Name of the column to apply the threshold filter to
### param threshold Numeric threshold value (rows with values > threshold are kept)
### param input_dir Directory containing input files (default: current directory)
### param output_dir Directory for output files (default: same as input_dir)
#
### return NULL (invisibly). Function works by creating files as a side effect.
#
### Examples
# # Example 1: Filter all class files for output values above 50
# filter_datasets_by_threshold(".*_class\\.csv", "output", 50)
# 
# # Example 2: Filter inhibition data files for values above 75, save to "filtered" directory
# filter_datasets_by_threshold("inhibition.*\\.csv", "inhibition_percent", 75, 
#                              output_dir = "filtered")
filter_datasets_by_threshold <- function(pattern, column_name, threshold, input_dir = ".", output_dir = NULL) {
  # Set output directory to input directory if not specified
  if (is.null(output_dir)) {
    output_dir <- input_dir
  }
  
  # Create output directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
    cat("Created output directory:", output_dir, "\n")
  }
  
  # Get list of files matching the pattern
  files <- list.files(path = input_dir, pattern = pattern)
  
  if (length(files) == 0) {
    warning("No files matching the pattern were found.")
    return(invisible(NULL))
  }
  
  cat("Found", length(files), "files matching pattern:", pattern, "\n")
  
  # Process each file
  for (file in files) {
    # Get filename without extension and path
    file_path <- file.path(input_dir, file)
    filename <- basename(file)
    filename_noext <- tools::file_path_sans_ext(filename)
    
    # Read the dataset with original column names preserved
    data <- data.frame(data.table::fread(file_path), check.names = FALSE)
    
    # Check if column exists in the dataset
    if (!(column_name %in% names(data))) {
      warning(paste("Column", column_name, "not found in", filename, "- skipping file."))
      next
    }
    
    # Filter rows where column value exceeds threshold
    filtered_data <- data[data[[column_name]] > threshold, ]
    
    # Skip if no rows match the condition
    if (nrow(filtered_data) == 0) {
      message(paste("No rows in", filename, "exceed the threshold of", threshold, "- skipping file."))
      next
    }
    
    # Create new filename with threshold
    new_filename <- paste0(filename_noext, "_above_", threshold, ".csv")
    output_path <- file.path(output_dir, new_filename)
    
    # Save the filtered dataset
    write.csv(filtered_data, file = output_path, row.names = FALSE)
    
    cat("Created", new_filename, "with", nrow(filtered_data), "out of", nrow(data), "rows.\n")
  }
  
  cat("Completed filtering", length(files), "files with threshold", threshold, "on column", column_name, "\n")
}
