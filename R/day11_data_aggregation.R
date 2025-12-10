library(tidyverse)
library(lubridate)
input_path <- "data/interim/02_uci_retail_cleaned.rds"
df_clean <- readRDS(input_path)

# Identify Top Selling Product
top_products <- df_clean %>%
  group_by(StockCode, Description) %>%
  summarise(TotalVolume = sum(Quantity), .groups = "drop") %>%
  arrange(desc(TotalVolume)) %>%
  slice(1:5)
print("--- Top 5 Best Selling Products ---")
print(top_products)

# Based on the output, we usually select the #1 product.
# In this dataset, '85123A' (White Hanging Heart) is typically the top seller.
target_sku <- top_products$StockCode[1]
print(paste("Selected Target SKU for Analysis:", target_sku))

# Filter & Aggregate
df_aggregated <- df_clean %>%
  filter(StockCode == target_sku) %>% # Filter: Keep only the target product
  mutate(Date = as.Date(InvoiceDate)) %>% # Prepare Date: Remove time component (HH:MM:SS) to group by Day
  group_by(Date, Price) %>% # Grouping: We need total quantity per price point per day
  summarise(DailyQuantity = sum(Quantity), .group="drop") %>% # Summarize: Calculate total daily quantity
  arrange(Date) # Sort: Keep it chronological

print("--- Aggregated Data Preview ---")
print(head(df_aggregated))

output_path <- "data/interim/03_uci_retail_aggregated.rds"
saveRDS(df_aggregated, output_path)

