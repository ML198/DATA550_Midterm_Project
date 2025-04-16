here::i_am(
  "code/01_demographics.R"
)
data <- read.csv(here::here("data", "f75_interim.csv"), header = TRUE)

library(tidyverse)
library(gtsummary)
library(labelled)
library(here)


#table1
var_label(data) <- list(
  agemons = "Age in months",
  weight = "Weight (kg)",
  muac = "MUAC (cm)",
  height = "Height (cm)",
  sex = "Sex",
  bfeeding = "Still Breastfeeding",
  kwash = "Kwashiorkor",
  oedema = "Oedema",
  shock = "Shock",
  diarrhoea = "Diarrhoea",
  malaria = "Malaria",
  sev_pneumonia = "Severe Pneumonia",
  ofillness = "Other Febrile Illness",
  arm = "Treatment Arm"
)


table1 <- data %>%
  select(arm, agemons, weight, muac, height,
         sex, bfeeding, kwash, oedema, shock,
         diarrhoea, malaria, sev_pneumonia, ofillness) %>%
  tbl_summary(by = arm, missing = "no") %>%
  add_overall() %>%
  add_p() %>%
  modify_spanning_header(c("stat_1", "stat_2") ~ "**Treatment Arm**")

saveRDS(
  table1,
  file = here::here("output", "table1_demographics.rds")
)




# Boxplots
boxplot1 <- data %>%
  ggplot(aes(x = sex, y = muac, fill = arm)) +
  geom_boxplot() +
  labs(title = "MUAC by Sex and Treatment Arm") +
  theme_minimal()

boxplot2 <- data %>%
  ggplot(aes(x = sex, y = weight, fill = arm)) +
  geom_boxplot() +
  labs(title = "Weight by Sex and Treatment Arm") +
  theme_minimal()


ggsave(
  filename = here::here("output", "figureA_boxplots.png"),
  gridExtra::grid.arrange(boxplot1, boxplot2, ncol = 2), width = 10, height = 5)



# Bar chart
symptom_vars <- c("shock", "oedema", "diarrhoea", "malaria", "sev_pneumonia", "ofillness")

data_long_symptoms <- data %>%
  select(arm, all_of(symptom_vars)) %>%
  pivot_longer(-arm, names_to = "symptom", values_to = "value") %>%
  filter(!is.na(value)) %>%
  group_by(arm, symptom, value) %>%
  summarise(count = n(), .groups = "drop")

barplot <- data_long_symptoms %>%
  ggplot(aes(x = symptom, y = count, fill = value)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ arm) +
  labs(title = "Symptom Frequencies by Study Arm", x = "Symptom", y = "Count") +
  theme_minimal()

ggsave(
  filename = here::here("output", "figureB_bar.png"), barplot, width = 10, height = 6)






