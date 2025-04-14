# Load necessary libraries
library(tidyverse)   
library(cowplot)    

here::i_am("code/03_trends.R  .R")
# 1. Read the dataset
df <- read_csv("data/f75_interim.csv")
df_analysis <- df %>% filter(days_stable != 999)


# 2. Calculate changes and rate of weight gain
df_analysis <- df_analysis %>%
  mutate(
    change_muac = muac2 - muac1,
    change_weight = weight2 - weight1,
    change_height = height2 - height,  # Using height at baseline vs discharge
    rate_weight_gain = (weight2 - weight1) / days_stable
  )

# 3. Create Summary Table of Changes over Time
summary_table <- summary_table <- df_analysis %>%
  select(days_stable, change_muac, change_weight, change_height, rate_weight_gain) %>%
  summarise_all(list(
    Min = ~min(., na.rm = TRUE),
    Median = ~median(., na.rm = TRUE),
    Mean = ~mean(., na.rm = TRUE),
    Max = ~max(., na.rm = TRUE),
    sd = ~sd(., na.rm = TRUE)
  )) %>%
  pivot_longer(cols = everything(), names_to = c("Variable", "Statistic"), names_pattern = "(.*)_(.*)") %>%
  pivot_wider(names_from = Variable, values_from = value)


# Save the summary table as an RDS file to output/table3_progression.rds
saveRDS(summary_table, "output/table3_progression.rds")


# 4. Prepare Data for the Line Plot

# Reshape data to long format for plotting aggregated trends over three time points:
# Baseline, Stabilization, and Discharge.
df_long <- df_analysis %>%
  select(subjid, muac, weight, muac1, weight1, muac2, weight2) %>%
  pivot_longer(
    cols = -subjid,
    names_to = "variable_time",
    values_to = "value"
  ) %>%
  mutate(
    time = case_when(
      grepl("1$", variable_time) ~ "Stabilization",
      grepl("2$", variable_time) ~ "Discharge",
      TRUE ~ "Baseline"
    ),
    variable = case_when(
      grepl("muac", variable_time) ~ "MUAC",
      grepl("weight", variable_time) ~ "Weight",
      TRUE ~ variable_time
    )
  ) %>%
  select(subjid, variable, time, value)

# Aggregate: calculate mean value for each measurement and time point.
agg_summary <- df_long %>%
  group_by(variable, time) %>%
  summarise(mean_value = mean(value, na.rm = TRUE), .groups = "drop")
# Set time point factor order
agg_summary$time <- factor(agg_summary$time, levels = c("Baseline", "Stabilization", "Discharge"))


# 5. Generate Figures

# (a) Line Plot: Aggregated Change in MUAC and Weight Over Time
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

# Save the line plot
ggsave("output/figureE_trends.png", plot = p_line, width = 7, height = 5, dpi = 300, bg = "white")

# (b) Scatterplot: Rate of Weight Gain vs. Days to Stabilization
p_scatter <- ggplot(df_analysis, aes(x = days_stable, y = rate_weight_gain)) +
  geom_point(color = "blue", alpha = 0.6) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(
    title = "Rate of Weight Gain vs. Days to Stabilization",
    x = "Days to Stabilization",
    y = "Rate of Weight Gain (kg/day)"
  ) +
  theme_minimal()

summary(lm(rate_weight_gain ~ days_stable, data = df_analysis))  

# Save the scatter plot
ggsave("output/figureF_gain_vs_time.png", plot = p_scatter, width = 7, height = 5, dpi = 300, bg = "white")
