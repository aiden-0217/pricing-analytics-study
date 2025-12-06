# Script: R/demand_functions.R
# Purpose: Define demand curve functions for pricing analysis

#' Linear Demand Function
#' 
#' @param price The selling price (numeric or vector)
#' @param intercept The theoretical demand when price is 0 (Market Size)
#' @param slope The price sensitivity (usually negative)
#' @return Predicted quantity (pmax ensures non-negative results)
demand_linear <- function(price, intercept = 1000, slope = -5) {
  
  # Calculate quantity based on linear equation
  q <- intercept + (slope * price)
  
  # Business Logic: Sales cannot be negative.
  # pmax(q, 0) compares q and 0, returning the larger of the two.
  return(pmax(q, 0))
}