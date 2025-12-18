library(tidyverse)

# Load Data
input_path <- "data/interim/02_uci_retail_cleaned.rds"
df_clean <- readRDS(input_path)

# Identify Top 10 Products
top_products <- df_clean %>%
  group_by(StockCode, Description) %>%
  summarise(TotalVolume = sum(Quantity), .groups = "drop") %>%
  arrange(desc(TotalVolume)) %>%
  slice(1:10)

# Batch Modeling Loop
results_list <- list()

for(i in 1:nrow(top_products)) {
  sku <- top_products$StockCode[i]
  desc <- top_products$Description[i]
  
  # Prepare Data
  df_sku <- df_clean %>%
    filter(StockCode == sku) %>%
    mutate(Date = as.Date(InvoiceDate)) %>%
    group_by(Date, Price) %>%
    summarise(DailyQuantity = sum(Quantity), .groups = "drop")
  
  if(nrow(df_sku) < 10) next
  
  # Run Model
  try({
    model <- lm(log(DailyQuantity) ~ log(Price), data = df_sku)
    model_sum <- summary(model)
    
    results_list[[i]] <- data.frame(
      StockCode = sku,
      Description = desc,
      Elasticity = round(coef(model)["log(Price)"], 2),
      R_Squared = round(model_sum$r.squared, 2),
      Significant = model_sum$coefficients[2, 4] < 0.05
    )
  }, silent = TRUE)
}

# Output Strategy Table
comparison_table <- bind_rows(results_list)

if(nrow(comparison_table) > 0) {
  final_strategy <- comparison_table %>%
    filter(Significant == TRUE) %>%
    mutate(
      Strategy = case_when(
        Elasticity < -1 ~ "Elastic (Promote)",
        Elasticity >= -1 ~ "Inelastic (Raise Price)",
        TRUE ~ "Other"
      )
    ) %>%
    arrange(Elasticity) %>%
    select(StockCode, Description, Elasticity, Strategy, R_Squared)
  
  print(final_strategy)
  saveRDS(final_strategy, "data/processed/product_portfolio_strategy.rds")
}