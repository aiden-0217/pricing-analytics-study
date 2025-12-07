# Script: profit_functions.R
# Purpose: Calculate profit based on demand and cost structures

# ✅ CORRECTED LINE: No "R/" because the files are neighbors
source("demand_function.R")

#' Linear Profit Function
#'
#' @param price The selling price (numeric or vector)
#' @param cost_unit Variable cost per unit (e.g., manufacturing cost)
#' @param intercept Demand intercept (Market Size)
#' @param slope Demand slope (Price Sensitivity)
#' @param cost_fixed Fixed costs (e.g., rent, salaries) - default is 0 for simple analysis
#' @return Predicted profit
profit_linear <- function(price, cost_unit, intercept = 1000, slope = -5, cost_fixed = 0) {
  
  # 1. Calculate Quantity
  quantity <- demand_linear(price, intercept, slope)
  
  # 2. Calculate Revenue
  revenue <- price * quantity
  
  # 3. Calculate Total Cost
  total_cost <- (cost_unit * quantity) + cost_fixed
  
  # 4. Calculate Profit
  profit <- revenue - total_cost
  
  return(profit)
}