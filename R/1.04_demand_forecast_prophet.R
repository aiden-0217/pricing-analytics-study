install.packages("prophet")

# Day 1.04: Predicting Future Demand with Facebook Prophet
# Goal: Build a forecast model incorporating Price effects

library(tidyverse)
library(prophet)
library(lubridate)

df_raw <- read_csv("data/processed/daily_demand_resort.csv")

# Data Preprocessing for Prophet
# Prophet strictly requires two specific column names:
# 'ds' = Date stamp (YYYY-MM-DD)
# 'y'  = The metric we want to predict (Demand/Bookings)
model_data <- df_raw %>%
  rename(ds = arrival_date, y = daily_bookings) %>%
  mutate(price = avg_price) %>% 
  select(ds, y, price)

# Initialize the Model
# We enable daily_seasonality to capture the "Weekend Effect"
# We enable yearly_seasonality to capture "High/Low Seasons"
m <- prophet(daily.seasonality = FALSE, yearly.seasonality = TRUE, weekly.seasonality = TRUE)

# Add External Regressor (Price)
# We tell the model that 'price' impacts 'y' (Demand)
# This allows the model to separate "True Seasonality" from "Price-driven changes"
m <- add_regressor(m, 'price')

# Fit the Model
# Training the model on our historical data
print("Training the model... this may take a moment.")
m <- fit.prophet(m, model_data)

# Create Future Dataframe
# We want to forecast the next 30 days
future <- make_future_dataframe(m, periods = 30)

# [CRITICAL STEP] Handling Future Regressors
# The model needs to know the 'price' for the next 30 days to predict demand.
# Strategy: We assume future prices will be similar to the most recent known prices.
# We join the historical prices and fill the future NAs with the last known price.
future <- future %>%
  left_join(model_data %>% select(ds, price), by = "ds") %>%
  fill(price, .direction = "down") 

# Generate Forecast
forecast <- predict(m, future)

# ========================================================
# Visualization
# ========================================================
# Plot A: The Forecast
# Black dots = Actual history
# Blue line = Model prediction
# Light blue area = Confidence interval
plot(m, forecast) +
  labs(title = "Resort Hotel Demand Forecast (Next 30 Days)",
       subtitle = "Model includes Price as an external regressor",
       x = "Date",
       y = "Daily Bookings")

# Plot B: Component Analysis (Decomposition)
# This breaks down the forecast into:
# 1. Trend (Is business growing?)
# 2. Weekly (Which days of the week are busiest?)
# 3. Yearly (Which months are the peak season?)
prophet_plot_components(m, forecast)
