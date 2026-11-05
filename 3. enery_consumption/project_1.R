install.packages(c("dplyr", "ggplot2", "caret", "corrplot", "scales", "tidyr"))
library(dplyr)
library(ggplot2)
library(caret)
library(corrplot)
library(scales)
library(tidyr)

options(scipen = 999)

# 1. DOWNLOAD / LOAD DATASET
energy <- read.csv("Energy_consumption_updated.csv", stringsAsFactors = FALSE)

# View dataset
head(energy)
str(energy)
summary(energy)
dim(energy)

# Check number of rows and columns
cat("Total Rows:", nrow(energy), "\n")
cat("Total Columns:", ncol(energy), "\n")

# Check Numerical and Categorical Features
numerical_cols <- names(energy)[sapply(energy, is.numeric)]
categorical_cols <- names(energy)[sapply(energy, function(x) is.character(x) || is.factor(x))]
numerical_cols
categorical_cols

# 2. MISSING VALUE HANDLING
# 2.1 Identify Missing Values
colSums(is.na(energy))

# Percentage of Missing Values
round(colSums(is.na(energy)) / nrow(energy) * 100, 2)

# 2.2 Method 1: Discard Instances (Remove Missing Rows)
energy_discard <- na.omit(energy)
dim(energy_discard)

# 2.3 Method 2: Replace Missing Values
# Numerical Features- Average Value (Mean)
energy$Temperature[is.na(energy$Temperature)] <- mean(energy$Temperature, na.rm = TRUE)
energy$Humidity[is.na(energy$Humidity)] <- mean(energy$Humidity, na.rm = TRUE)
energy$Occupancy[is.na(energy$Occupancy)] <- mean(energy$Occupancy, na.rm = TRUE)

# Categorical Features -> Most Frequent Value (Mode)

get_mode <- function(x) {
  ux <- unique(na.omit(x))
  ux[which.max(tabulate(match(x, ux)))]
}

energy$HVACUsage[is.na(energy$HVACUsage)] <- get_mode(energy$HVACUsage)
energy$LightingUsage[is.na(energy$LightingUsage)] <- get_mode(energy$LightingUsage)

# 2.4 Check Missing Values Again

colSums(is.na(energy))

# 3. ADD, DETECT AND HANDLE NOISE DATA

# 3.1 Create a Separate Dataset for Noise Demonstration

energy_noisy <- energy

# Add Numerical Noise
energy_noisy$Temperature[1] <- 150
energy_noisy$Humidity[2] <- -20

# Add Categorical Noise
energy_noisy$HVACUsage[1] <- "Unknown"
energy_noisy$LightingUsage[2] <- "Invalid"

# 3.2 Detect Numerical Noise
energy_noisy$Temperature[energy_noisy$Temperature > 50 | energy_noisy$Temperature < -10]
energy_noisy$Humidity[energy_noisy$Humidity > 100 | energy_noisy$Humidity < 0]

# 3.3 Detect Categorical Noise
unique(energy_noisy$HVACUsage)
unique(energy_noisy$LightingUsage)

# 3.4 Handle Numerical Noise
energy_noisy$Temperature[energy_noisy$Temperature > 50 | energy_noisy$Temperature < -10] <- median(energy$Temperature, na.rm = TRUE)
energy_noisy$Humidity[energy_noisy$Humidity > 100 | energy_noisy$Humidity < 0] <- median(energy$Humidity, na.rm = TRUE)

# 3.5 Handle Categorical Noise
energy_noisy$HVACUsage[!energy_noisy$HVACUsage %in% unique(energy$HVACUsage)] <- get_mode(energy_noisy$HVACUsage)
energy_noisy$LightingUsage[!energy_noisy$LightingUsage %in% unique(energy$LightingUsage)] <- get_mode(energy_noisy$LightingUsage)

# 3.6 Check Noise Handling
unique(energy_noisy$HVACUsage)
unique(energy_noisy$LightingUsage)
summary(energy_noisy)

# 4. CHECK INVALID DATA
# 4.1 Check Unique Values
unique(energy$DayOfWeek)
unique(energy$Holiday)
unique(energy$HVACUsage)
unique(energy$LightingUsage)

# 4.2 Standardize Inconsistent Categorical Values
energy$DayOfWeek <- tolower(trimws(energy$DayOfWeek))
energy$Holiday <- tolower(trimws(energy$Holiday))
energy$HVACUsage <- tolower(trimws(energy$HVACUsage))
energy$LightingUsage <- tolower(trimws(energy$LightingUsage))

# 4.3 Check Again
unique(energy$DayOfWeek)
unique(energy$Holiday)
unique(energy$HVACUsage)
unique(energy$LightingUsage)

# 4.4 Check Invalid Numerical Values
summary(energy$Temperature)
summary(energy$Humidity)
summary(energy$EnergyConsumption)

# Replace Invalid Numerical Values
energy$Temperature[energy$Temperature > 50 | energy$Temperature < -10] <- median(energy$Temperature, na.rm = TRUE)
energy$Humidity[energy$Humidity > 100 | energy$Humidity < 0] <- median(energy$Humidity, na.rm = TRUE)
energy$EnergyConsumption[energy$EnergyConsumption < 0 | energy$EnergyConsumption > 300] <- median(energy$EnergyConsumption, na.rm = TRUE)

# 4.5 Check Duplicate Records
sum(duplicated(energy))
energy <- distinct(energy)

# 5. DATA NORMALIZATION AND TRANSFORMATION
# 5.1 Data Wrangling
# Tidy Data Check

head(energy)
# 5.2 Filtering
# Energy Consumption Above 100
energy %>% filter(EnergyConsumption > 100)

# 5.3 Sorting
# Highest Energy Consumption
energy %>% arrange(desc(EnergyConsumption))

# 5.4 Joins and Merges
energy_info <- data.frame(
  ID = c(1, 2, 3),
  Building = c("Office", "School", "Hospital")
)
energy_details <- data.frame(
  ID = c(1, 2, 3),
  Category = c("Commercial", "Educational", "Medical")
)
merge(energy_info, energy_details, by = "ID")

# 5.5 Reshaping Data
energy_sample <- data.frame(
  Building = c("Office", "School"),
  Temperature = c(25, 30),
  Humidity = c(60, 70)
)

# Wide to Long
energy_long <- pivot_longer(
  energy_sample,
  cols = c(Temperature, Humidity),
  names_to = "Measurement",
  values_to = "Value"
)
energy_long

# 5.6 Encoding Categorical Variables
# Convert to Factors
energy$HVACUsage <- as.factor(energy$HVACUsage)
energy$LightingUsage <- as.factor(energy$LightingUsage)
energy$DayOfWeek <- as.factor(energy$DayOfWeek)
energy$Holiday <- as.factor(energy$Holiday)

# Numeric Encoding
energy$HVAC_Code <- as.numeric(energy$HVACUsage)

# 5.7 Normalization
# Min-Max Scaling

energy$Temperature_Norm <- (energy$Temperature - min(energy$Temperature)) / (max(energy$Temperature) - min(energy$Temperature))
energy$Humidity_Norm <- (energy$Humidity - min(energy$Humidity)) / (max(energy$Humidity) - min(energy$Humidity))
energy$EnergyConsumption_Norm <- (energy$EnergyConsumption - min(energy$EnergyConsumption)) / (max(energy$EnergyConsumption) - min(energy$EnergyConsumption))

# 5.8 Standardization
energy$Temperature_Std <- scale(energy$Temperature)
energy$Humidity_Std <- scale(energy$Humidity)
energy$EnergyConsumption_Std <- scale(energy$EnergyConsumption)

# 5.9 Feature Engineering
# Create Temperature Category
energy$Temperature_Category <- ifelse(
  energy$Temperature < 20, "Low",
  ifelse(energy$Temperature < 30, "Moderate", "High")
)

# Create High Energy Consumption Indicator
energy$High_Energy_Consumption <- ifelse(
  energy$EnergyConsumption > median(energy$EnergyConsumption),
  1, 0
)
# Check New Features
head(energy)

# 6. CHECK DATA OUTLIERS
# 6.1 Detect Outliers Using Boxplots
boxplot(energy$Temperature, main = "Temperature Distribution", col = "lightblue")
boxplot(energy$Humidity, main = "Humidity Distribution", col = "lightgreen")
boxplot(energy$EnergyConsumption, main = "Energy Consumption Distribution", col = "salmon")

# 6.2 Detect Outliers Using IQR Method
Q1 <- quantile(energy$EnergyConsumption, 0.25)
Q3 <- quantile(energy$EnergyConsumption, 0.75)
IQR_value <- IQR(energy$EnergyConsumption)
lower <- Q1 - 1.5 * IQR_value
upper <- Q3 + 1.5 * IQR_value

# Identify Outliers
outliers <- energy$EnergyConsumption[
  energy$EnergyConsumption < lower |
    energy$EnergyConsumption > upper
]

outliers

# Total Number of Outliers
length(outliers)

# 7. DESCRIPTIVE STATISTICS (PLOTS)
# 7.1 Summary Statistics
summary(energy)

# Mean
sapply(energy[numerical_cols], mean, na.rm = TRUE)
# Median
sapply(energy[numerical_cols], median, na.rm = TRUE)
# Standard Deviation
sapply(energy[numerical_cols], sd, na.rm = TRUE)

# 7.2 Histogram of Temperature
hist(energy$Temperature, 
     main = "Distribution of Temperature", 
     col = "lightblue", xlab = "Temperature")
# 7.3 Histogram of Energy Consumption
hist(energy$EnergyConsumption, 
     main = "Distribution of Energy Consumption", 
     col = "salmon", xlab = "Energy Consumption")

# 7.4 Boxplot of Energy Consumption by HVAC Usage
ggplot(energy, aes(x = HVACUsage, y = EnergyConsumption, fill = HVACUsage)) +
  geom_boxplot() +
  labs(title = "Energy Consumption by HVAC Usage", x = "HVAC Usage", y = "Energy Consumption") +
  theme_minimal()

# 8. DATASET SPLIT (TRAINING 80%, TESTING 20%)
set.seed(123)
train_index <- createDataPartition(
  energy$EnergyConsumption,
  p = 0.80,
  list = FALSE
)

# Training Dataset (80%)
train_data <- energy[train_index, ]

# Testing Dataset (20%)
test_data <- energy[-train_index, ]

# Check Dataset Dimensions
dim(train_data)
dim(test_data)

# Check Percentage
nrow(train_data) / nrow(energy) * 100
nrow(test_data) / nrow(energy) * 100

# 9. FEATURE SELECTION
# 9.1 Select Numerical Features from Training Data
num_cols <- c("Temperature", "Humidity", "SquareFootage", "Occupancy", "RenewableEnergy", "EnergyConsumption")
num_data <- train_data[, num_cols]

# 9.2 Correlation Matrix
cor_matrix <- cor(num_data, use = "complete.obs")
cor_matrix

# 9.3 Correlation Plot
corrplot(
  cor_matrix,
  method = "color",
  type = "upper",
  addCoef.col = "black",
  tl.col = "black"
)

# 9.4 Correlation with Target Variable
cor_with_target <- cor_matrix[, "EnergyConsumption"]
sort(abs(cor_with_target), decreasing = TRUE)
