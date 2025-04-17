here::i_am("code/02_outcome.R")
absolute_file_path <- here::here("data/f75_interim.csv" )
data <- read.csv(absolute_file_path, header = TRUE)

library(tidyverse)
library(ggplot2)
library(labelled)
library(gtsummary)

# table2_outcome.rds
data$arm <- factor(data$arm)
data$discharged2 <- factor(data$discharged2)

# create table of comparison of mean of days to stabilization by treatment group
table1 <- data %>%
  select(arm, days_stable) %>%
  tbl_summary(
    by = arm,
    statistic = list(all_continuous() ~ "{mean} ({sd})"),
    label = list(
      days_stable = "Days to Stabilization"
    ),
    missing = "no"
  )

# create table of frequency of whether discharged
table2 <- data %>%
  select(discharged2) %>%
  tbl_summary(
    statistic = list(all_categorical() ~ "{n} ({p}%)"),
    label = list(discharged2 = "Discharged vs Withdrawn/Dead"),
    missing = "no"
  )

# merge two tables
final_table <- tbl_stack(list(table1, table2))

saveRDS(
  final_table,
  file = here::here("output/table2_outcome.rds")
)


# figureC_daysstable.png
# boxplot of days to stabilization by treatment group (arm)
# remove days = 999
data_rm <- subset(data, days_stable!= 999)
figureC <- 
  ggplot(data = data_rm, aes(x = factor(arm), y = days_stable)) +
  geom_boxplot(fill = "pink", color = "grey", outlier.shape = NA) +
  stat_summary(fun = mean, geom = "point", shape = 20, size = 2, color = "black") +
  coord_cartesian(ylim = c(0, 8))+
  labs(
    title = "Boxplot of Days to Stabilization by Treatment Group",
    x = "Treatment Group (Arm)",
    y = "Days to Stabilization"
  ) +
  theme_minimal()

ggsave(
  here::here("output/figureC_daysstable.png"),
  plot = figureC, 
  device = "png"
)

# figureD_discharge.png
# bar chart of frequency of patients discharged vs withdrawn/died
figureD <- 
  ggplot(data, aes(x = discharged2)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(
    title = "Frequency of patients discharged and withdrawn/died",
    x = "discharged vs withdrawn/died",
    y = "Count"
  ) +
  theme_minimal()

ggsave(
  here::here("output/figureD_discharge.png"),
  plot = figureD, 
  device = "png"
)





