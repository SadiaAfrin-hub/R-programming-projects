install.packages("ggplot2")
install.packages("corrplot")
install.packages("scales")

library(ggplot2)
library(corrplot)
library(scales)
options(scipen = 999)

euro <- read.csv("EuroEnergy.csv")
colnames(euro)[1] <- "Country"

head(euro)
View(euro)
str(euro)
summary(euro)

# Histogram
hist(
  euro$gdp,
  main = "Distribution of GDP",
  xlab = "GDP",
  col = "lightblue",
  border = "black"
)

ggplot(
  euro,
  aes(x = gdp)
) +
  geom_histogram(
    bins = 10,
    fill = "steelblue",
    color = "black"
  ) +
  scale_x_continuous(labels = comma) +
  labs(
    title = "Distribution of GDP",
    x = "GDP",
    y = "Frequency"
  )

# Boxplot
boxplot(
  euro$gdp,
  main = "Boxplot of GDP",
  col = "lightgreen"
)

boxplot(
  euro$energy,
  main = "Boxplot of Energy",
  col = "yellow"
)

ggplot(euro, aes(x = as.factor(1), y = gdp, fill = as.factor(1))) +
  geom_boxplot(alpha = 0.7, outlier.color = "#E74C3C", outlier.shape = 16) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Boxplot of GDP",
    x = "",
    y = "GDP",
    fill = "Legend"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Scatterplot
ggplot(
  euro,
  aes(
    x = gdp,
    y = energy
  )
) +
  geom_point(
    size = 3,
    color = "blue"
  ) +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "GDP vs Energy",
    x = "GDP",
    y = "Energy"
  )

ggplot(
  euro,
  aes(
    x = gdp,
    y = energy
  )
) +
  geom_point(size = 3) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    color = "red"
  ) +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "GDP vs Energy"
  )

# Correlation
cor(
  euro$gdp,
  euro$energy
)

cor_matrix <- cor(euro[, c("gdp", "energy")])
cor_matrix

corrplot(
  cor_matrix,
  method = "color",
  type = "upper"
)

pairs(
  euro[, c("gdp", "energy")],
  main = "Pairwise scatterplots"
)

# Three Key Findings
cor_value <- cor(euro$gdp, euro$energy)

cat("THREE KEY FINDINGS\n\n")
cat("1. Correlation between GDP and Energy =", round(cor_value, 3), "\n\n")

cat("2.Top countries by GDP:\n")
print(euro[order(-euro$gdp), c("Country", "gdp")][1:3, ])

cat("\n 3.Bottom countries by Energy:\n")
print(euro[order(euro$energy), c("Country", "energy")][1:3, ])