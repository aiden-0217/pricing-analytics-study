library(ggplot2)

source("demand_function.R")
source("profit_functions.R")

sim_data <- data.frame(price = seq(50, 200, by=0.5))

sim_data$quantity <- demand_linear(sim_data$price, intercept = 1000, slope = -5)
sim_data$profit   <- profit_linear(sim_data$price, cost_unit = 50, intercept = 1000, slope = -5)

best_point <- sim_data[which.max(sim_data$profit), ]

print(paste("best price :$", best_point$price))
print(paste("biggest profit :$", best_point$profit))

ggplot(sim_data, aes(x = price, y = profit)) +
  geom_line(color  = "blue", size = 1.2) +
  geom_vline(xintercept = best_point$price, linetype = "dashed", color = "red") + 
  geom_text(data = best_point, aes(x = price, y = profit, 
                                   label = paste("Optimal Price: $", price)),
            vjust = -0.5, color = "#e74c3c", fontface = "bold") +
  labs(title = "Price Optimization Model",
       subtitle = "Finding the profit-maximizing price point",
       x = "Selling Price ($) ",
       y = "Predicted Profit ($) ") + 
  theme_minimal()
