# Midterm Project - Group 8

**Team Members**: Youwei Hu (Leader), Yuchi Liu, Siyu Zhai, Mingrui Li (Coders) 

## 👀 Project Overview

This project analyzes interim data `data/f75_interim.csv` from a RCT that investigated the effectiveness of a modified milk formula (mF75), compared to the standard F75 formula for treating hospitalized children with severe acute malnutrition (SAM).

## 📝 Structure

Using the first 6 months of data, our team will perform the following structured analyses:

🔹 1. Baseline Demographics & Clinical Profile We will summarize the baseline characteristics of the children enrolled, stratified by treatment group (F75 vs mF75), to assess balance post-randomization.

-   Code: `code/01_demographics.R`

-   Output: `output/table1_demographics.rds`

-   Visualizations:

`figureA_boxplots.png` -- Boxplots of MUAC and weight by sex and treatment group

`figureB_bar.png` -- Bar charts of clinical symptoms by group

🔹 2. Clinical Outcomes We will compare outcomes such as time to stabilization, discharge status, and mortality rates between the treatment arms. This will include both tabular summaries and exploratory plots.

-   Code: `code/02_outcomes.R`

-   Output: `output/table2_outcomes.rds`

-   Visualizations:

`figureC_daysstable.png` -- Boxplot of days to stabilization by treatment group

`figureD_discharge.png` -- Bar chart of discharge vs withdrawal/death

🔹 3. Nutritional Progress & Trends Over Time We will analyze the change in anthropometric indicators (MUAC, weight, height) from admission to discharge, and compute the rate of weight gain. These trends will help us assess recovery patterns.

-   Code: `code/03_trends.R`

-   Output: `output/table3_progression.rds`

-   Visualizations:

`figureE_trends.png` -- Line plot of MUAC/weight progression

`figureF_gain_vs_time.png` -- Scatterplot of weight gain vs. stabilization days

## 📦 Reproducibility  

Generation The project is structured for full reproducibility:

1.  Parameters (e.g., which variables to include or filter by group) can be modified via config.yaml

2.  Automation is supported via Makefile

## 📜 Report
Final integrated report will be rendered using R Markdown: `report.Rmd` 

- Summarize baseline demographics and clinical conditions of enrolled children by treatment group (F75 vs. mF75).

-   Visualize and compare clinical symptom patterns, such as edema, diarrhea, and pneumonia, across treatment groups.

-   Analyze outcomes, including discharge status and days to stabilization, to evaluate treatment effectiveness.

-   Assess anthropometric changes (MUAC, weight, height) over time and compute rates of weight gain.

-   Generate reproducible tables and figures using R scripts and parameter settings specified in a configuration file (config.yaml), allowing flexible filtering and formatting of results.

The overall goal is to provide a comprehensive statistical exploration of how children responded to each formula and to uncover early indicators of treatment efficacy, symptom patterns, and recovery trends in a vulnerable population.
