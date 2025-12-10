library(tidyverse)
library(ggplot2)
input_path <- "data/interim/03_uci_retail_aggregated.rds"
df <- readRDS(input_path)

# Log-Log Regression
# Formula: log(Quantity) = Intercept + Slope * log(Price)
# The slope coefficient IS the Price Elasticity
model <- lm(log(DailyQuantity) ~ log(Price), data = df)
elasticity <- coef(model)["log(Price)"]
summary(model)
print(paste("Price Elasticity (PED):", round(elasticity, 4)))

# Plot actual data points vs. the regression line
plot <- ggplot(df, aes(x = Price, y = DailyQuantity)) +
  geom_point(alpha = 0.5, color = "#2c3e50") +
  geom_smooth(method = "lm", formula = y ~ x, color = "#e74c3c", se = TRUE) +
  scale_x_log10() + 
  scale_y_log10() +
  labs(
    title = paste("Price Elasticity Model (PED =", round(elasticity, 2), ")"),
    subtitle = "Log-Log Regression Analysis",
    x = "Log(Price)",
    y = "Log(Daily Quantity)"
  ) +
  theme_minimal()
print(plot)

saveRDS(model, "data/processed/elasticity_model.rds")