library(tidyverse)
library(lubridate)

# 1. Load Raw Data
file_path <- "data/raw/online_retail_ii.rds"
raw_data <- readRDS(file_path)

# 2. Data Slicing (UK Only + Dec/Jan)
clean_data <- raw_data %>%
  filter(Country == "United Kingdom") %>%
  mutate(InvoiceDate = as.POSIXct(InvoiceDate)) %>%
  filter(month(InvoiceDate) %in% c(12,1))

# 3. Save Interim Data
saveRDS(clean_data, "data/interim/01_uci_retail_uk_filtered.rds")