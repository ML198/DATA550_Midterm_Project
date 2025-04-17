library(tidyverse)
library(cowplot)
library(here)

here::i_am("code/03_trends.R") 

df <- read_csv(here("data", "f75_interim.csv"))

# Clean and compute changes
df_analysis <- df %>%
  filter(days_stable != 999) %>%
  mutate(
    change_muac = muac2 - muac1,
    change_weight = weight2 - weight1,
    change_height = height2 - height,  
    rate_weight_gain = change_weight / days_stable
  )

# Generate summary table: changes in anthropometrics & weight gain rate
summary_table <- df_analysis %>%
  select(days_stable, change_muac, change_weight, change_height, rate_weight_gain) %>%
  summarise(across(everything(), list(
    Min = ~min(., na.rm = TRUE),
    Median = ~median(., na.rm = TRUE),
    Mean = ~mean(., na.rm = TRUE),
    Max = ~max(., na.rm = TRUE),
    SD = ~sd(., na.rm = TRUE)
  ))) %>%
  pivot_longer(cols = everything(), names_to = c("Variable", "Statistic"), names_pattern = "(.*)_(.*)") %>%
  pivot_wider(names_from = Variable, values_from = value)

saveRDS(summary_table, here::here("output", "table3_progression.rds"))
# Prepare long format table for plotting 
df_long <- df_analysis %>%
  select(subjid, muac, weight, muac1, weight1, muac2, weight2) %>%
  pivot_longer(-subjid, names_to = "variable_time", values_to = "value") %>%
  mutate(
    time = case_when(
      str_detect(variable_time, "1$") ~ "Stabilization",
      str_detect(variable_time, "2$") ~ "Discharge",
      TRUE ~ "Baseline"
    ),
    variable = case_when(
      str_detect(variable_time, "muac") ~ "MUAC",
      str_detect(variable_time, "weight") ~ "Weight",
      TRUE ~ variable_time
    ),
    time = factor(time, levels = c("Baseline", "Stabilization", "Discharge"))
  ) %>%
  select(subjid, variable, time, value)

# Aggregated trends over time 
agg_summary <- df_long %>%
  group_by(variable, time) %>%
  summarise(mean_value = mean(value, na.rm = TRUE), .groups = "drop")

# Line Plot: Aggregated Change in MUAC and Weight
p_line <- ggplot(agg_summary %>% filter(variable %in% c("MUAC", "Weight")),
                 aes(x = time, y = mean_value, group = variable, color = variable)) +
  geom_line(size = 1.2) +
  geom_point(size = 3) +
  labs(
    title = "Aggregated Change in MUAC and Weight Over Time",
    x = "Time Point",
    y = "Mean Value",
    color = "Measurement"
  ) +
  theme_minimal()

ggsave(here("output", "figureE_trends.png"), plot = p_line, width = 7, height = 5, dpi = 300, bg = "white")

# Scatterplot: Rate of Weight Gain vs. Days to Stabilization
p_scatter <- ggplot(df_analysis, aes(x = days_stable, y = rate_weight_gain)) +
  geom_point(color = "blue", alpha = 0.6) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(
    title = "Rate of Weight Gain vs. Days to Stabilization",
    x = "Days to Stabilization",
    y = "Rate of Weight Gain (kg/day)"
  ) +
  theme_minimal()

ggsave(here("output", "figureF_gain_vs_time.png"), plot = p_scatter, width = 7, height = 5, dpi = 300, bg = "white")