library(tidyverse)
pacing_data <- read_csv("data/processed/resort_hotel_pacing_curve.csv")

target_date <-"2016-08-15"

single_day_curve <- pacing_data %>%
  filter(stay_date == target_date) %>%
  filter(lead_time <= 100)

ggplot(single_day_curve, aes(x = lead_time, y = otb_rooms)) +
  geom_line(color = "#2E86C1", linewidth = 1.2) +
  geom_area(fill = "#2E86C1", alpha = 0.1) +
  scale_x_reverse(breaks = seq(0, 100, 10)) +
  labs(
    title = paste("Booking Pace Curve for Stay Date:", target_date),
    subtitle = "Visualizing demand accumulation velocity (OTB Rooms)",
    x = "Lead Time (Days before Arrival)",
    y = "Rooms On The Books (Cumulative)",
    caption = "Data Source: Hotel Booking Demand Dataset") +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    panel.grid.minor = element_blank()
  )
  
