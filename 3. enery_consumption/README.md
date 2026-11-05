# Energy Consumption Data Cleaning and Preprocessing

## Project Overview

This project uses R to perform data cleaning, data preprocessing, exploratory analysis, and feature selection on an energy consumption dataset. It demonstrates how to inspect a dataset, handle missing values, detect and correct invalid or noisy observations, transform variables, explore distributions, and prepare training and testing subsets.

## Dataset

The project uses an energy consumption dataset containing 5,000 records and 12 columns.

**Input file:** `Energy_consumption_dataset.csv`  
**Preprocessed file used by the R script:** `Energy_consumption_updated.csv`

The dataset includes the following variables:

- `Month` and `Hour`
- `DayOfWeek` and `Holiday`
- `Temperature` and `Humidity`
- `SquareFootage` and `Occupancy`
- `HVACUsage` and `LightingUsage`
- `RenewableEnergy`
- `EnergyConsumption`

Keep both CSV files in the same folder as the R script. The script currently reads `Energy_consumption_updated.csv`.

## Project Files

- `project_1.R` — R script for data inspection, cleaning, preprocessing, visualization, dataset splitting, and correlation-based feature analysis.
- `Energy_consumption_dataset.csv` — original dataset.
- `Energy_consumption_updated.csv` — updated dataset used as the script's input.
- `.Rhistory` and `.RData` — local R session files; these are not required to run the project and generally should not be committed to GitHub.

## Tools and Packages

- R
- RStudio (recommended)
- `dplyr`
- `ggplot2`
- `caret`
- `corrplot`
- `scales`
- `tidyr`

Install the required packages in R with:

```r
install.packages(c("dplyr", "ggplot2", "caret", "corrplot", "scales", "tidyr"))
```

## How to Run

1. Download or clone the repository.
2. Open the project folder in RStudio.
3. Make sure `project_1.R` and `Energy_consumption_updated.csv` are in the same folder.
4. Install the required packages if they are not already installed.
5. Open `project_1.R` and run the script.

The script reads the updated CSV using a relative file name, so run it with the project folder as the working directory.

## Analysis and Preprocessing Workflow

### 1. Dataset Loading and Inspection
- Load the updated energy consumption CSV.
- Inspect the first rows, structure, summary statistics, and dimensions.
- Identify numerical and categorical columns.

### 2. Missing Value Handling
- Identify missing values and calculate their percentages.
- Demonstrate row removal using `na.omit()`.
- Replace missing numerical values with column means.
- Replace missing categorical values with the mode.
- Check missing values again after handling.

### 3. Noise Detection and Handling
- Create a separate copy of the data for a noise-handling demonstration.
- Insert example numerical and categorical noise values.
- Detect unusual numerical values and unexpected categorical labels.
- Replace the inserted numerical noise with median values and invalid categories with modal values.

### 4. Invalid Data and Duplicate Checks
- Inspect unique categorical values.
- Standardize categorical text using lowercase conversion and whitespace trimming.
- Check numerical summaries and replace values outside the script's specified bounds.
- Count and remove duplicate records.

### 5. Data Wrangling and Transformation
- Demonstrate filtering and sorting with `dplyr`.
- Demonstrate joining two small example data frames.
- Reshape example data from wide to long format using `pivot_longer()`.
- Convert selected categorical columns to factors and demonstrate numeric encoding.
- Apply min-max normalization and standardization to selected numerical columns.
- Create derived features for temperature categories and high energy consumption.

### 6. Outlier Detection
- Visualize temperature, humidity, and energy consumption using boxplots.
- Identify energy consumption outliers using the IQR method.

### 7. Descriptive Statistics and Visualization
- Generate summary statistics.
- Calculate mean, median, and standard deviation for numerical features.
- Create histograms for temperature and energy consumption.
- Compare energy consumption across HVAC usage categories with a boxplot.

### 8. Training and Testing Split
- Split the data into training (80%) and testing (20%) subsets.
- Use a fixed random seed for reproducibility.
- Check the dimensions and proportions of both subsets.

### 9. Correlation-Based Feature Analysis
- Select numerical features from the training data.
- Calculate a correlation matrix.
- Visualize correlations with `corrplot()`.
- Examine the absolute correlations with `EnergyConsumption`.

## Important Notes

- The R script reads `Energy_consumption_updated.csv`, not `Energy_consumption_dataset.csv`. Keep the filename unchanged or update the path in the script.
- The noise values are deliberately inserted into a separate copy (`energy_noisy`) to demonstrate noise detection and handling; they are not original observations from the source dataset.
- The script applies specific value bounds for selected columns. Review these thresholds in the code and confirm they are appropriate for the dataset before using the cleaned data in further analysis.
- The script demonstrates preprocessing and correlation-based feature analysis. It does not currently train or evaluate a predictive machine learning model.
- `.RData` and `.Rhistory` are local R session files and are not necessary for reproducing the analysis.

## Project Purpose

The project provides practical experience with common R data preparation techniques and exploratory analysis for an energy consumption dataset.
