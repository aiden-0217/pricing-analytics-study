source("demand_function.R")
source("profit_functions.R")

intercept <- 1000  
slope <- -5       
cost_unit <- 50   

calculus_price <- (intercept - (cost_unit * slope)) / (-2 * slope)

print(paste("1.best price by calculas: $", calculus_price))

target_function <- function(p) {
  profit_linear(p, cost_unit, intercept, slope)
}

opt_result <- optimize(f = target_function, 
                       interval = c(0, 300), 
                       maximum = TRUE) 

algo_price <- opt_result$maximum

print(paste("2.best price by optimization: $", round(algo_price, 2)))

if(abs(calculus_price - algo_price) < 0.001) {
  print("✅ ")
} else {
  print("❌ ")
}