library(tidyverse)
df_raw <- readRDS("data/interim/01_uci_retail_uk_filtered.rds")
print(paste("Original row number:", nrow(df_raw)))

# Step 1: Remove Returns
df_step1 <- df_raw %>%
  # Filter out InvoiceNo starting with "C"
  filter(!str_detect(Invoice, "^C"))
print(paste("Rows after removing returns:", nrow(df_step1)))

# Step 2: Remove Noise(Non-Goods)
# Define blacklist for non-product codes
noise_codes <- c("POSTAGE", "DOTCOM PPOSTAGE", "M", "D")
df_step2 <- df_step1 %>%
  # Keep rows where StockCode is NOT in the noise_codes list
  filter(!StockCode %in% noise_codes)
print(paste("Rows after removing noise:", nrow(df_step2)))

# Step 3: Remove Invalid Price or Quantity records
df_step3 <- df_step2 %>%
  filter(Price > 0, Quantity >0)
print(paste("Rows after removing invalid values:", nrow(df_step3)))

# Step 4: Remove Outliers (IQR Method)
# 4.1 Calculate 25th and 75th percentiles
Q1 <- quantile(df_step3$Quantity, 0.25)
Q3 <- quantile(df_step3$Quantity, 0.75)
IQR_val <- Q3 - Q1
# 4.2 Set Upper Bound: Anything above Q3 + 1.5 * IQR is an outlier
upper_bound <- Q3 +1.5*IQR_val
print(paste("Outlier Cap (Quantity Upper Bound):", upper_bound))
# 4.3 Filter: Keep orders with Quantity <= Upper Bound
df_clean <- df_step3 %>%
  filter(Quantity <= upper_bound)
print(paste("Final Clean Rows:", nrow(df_clean)))

saveRDS(df_clean, "data/interim/02_uci_retail_cleaned.rds")
