library(dplyr)
library(ggplot2)
library(plotly)
library(tidyverse)
library(ggrepel)
library(lintr)
library(styler)

#Loading in the dataframe
income_df <- read.csv("inc_occ_gender.csv", stringsAsFactors = FALSE)

#Converting char values to numeric values for affected columns.
all_weekly_numeric <- as.numeric(income_df %>% pull(All_weekly))
m_weekly_numeric <- as.numeric(income_df %>% pull(M_weekly))
f_weekly_numeric <- as.numeric(income_df %>% pull(F_weekly))

#Replacing char valued columns to numeric values.
income_df <- income_df %>% mutate(All_weekly = all_weekly_numeric,
              M_weekly = m_weekly_numeric, F_weekly = f_weekly_numeric)

#Dataframe without the top "All Occupations" row
income_df_excluding_all <- income_df %>% slice(-1)

#Filter out all the NA values.
filtered_income_df <- income_df_excluding_all %>%
                      filter(F_weekly != "Na" & M_weekly != "Na")

occupation_raw <- filtered_income_df %>% 
  filter(!(Occupation %in%
             c("MANAGEMENT", "BUSINESS", "COMPUTATIONAL",
               "ENGINEERING", "SCIENCE", "LEGAL",
               "EDUCATION", "ART", "HEALTHCARE PROFESSIONAL",
               "HEALTHCARE SUPPORT", "PROTECTIVE SERVICE",
               "CULINARY", "GROUNDSKEEPING", "SERVICE",
               "SALES", "OFFICE", "AGRICULTURAL",
               "CONSTRUCTION", "MAINTENANCE", "PRODUCTION",
               "TRANSPORTATION", "SOCIAL SERVICE")))

# Analysis
#Finding the max median weekly pay.
max_men_wage <- occupation_raw %>%
  summarise(max_M_weekly = max(M_weekly, na.rm = TRUE))

max_women_wage <- occupation_raw %>%
  summarise(max_F_weekly = max(F_weekly, na.rm = TRUE))

diff_wage <- max_men_wage - max_women_wage

# Number of occupations where men have a higher median weekly salary.
number_men_pay_gap <- occupation_raw %>%
  filter(M_weekly > F_weekly) %>%
  summarise(number_male_pay_gap = n()) %>%
  pull(number_male_pay_gap)

# Number of occupations where women have a higher median weekly salary.
number_women_pay_gap <- occupation_raw %>%
  filter(F_weekly > M_weekly) %>%
  summarise(number_women_pay_gap = n()) %>%
  pull(number_women_pay_gap)

# Total number of occupations excluding Na values
total_filtered_occupations <- occupation_raw %>%
  summarise(number_of_observations = n()) %>%
  pull(number_of_observations)

# Proportion of jobs that men are being paid more than women
men_women_pay_job_ratio <- number_men_pay_gap / number_women_pay_gap

# Percentage of jobs that men are being paid more than women
men_percentage <- round((number_men_pay_gap / total_filtered_occupations),
                        digits = 2) * 100

# Percentage of jobs that women are being paid more than women
women_percentage <- round((number_women_pay_gap / total_filtered_occupations),
                    digits = 2) * 100

# Dataframe for pie chart
data <- data.frame(group = c("Men", "Women"),
                   value = c(men_percentage, women_percentage))

#New Pie Position
df2 <- data %>%
  mutate(csum = rev(cumsum(rev(value))),
         pos = value / 2 + lead(csum, 1),
         pos = if_else(is.na(pos), value / 2, pos))


# Top 10 Jobs Where Men Are Paid More Than Women
top_pay_difference <- occupation_raw %>%
  mutate(pay_difference = M_weekly - F_weekly) %>%
  top_n(10, pay_difference)

high_occ_gap <- occupation_raw %>%
  mutate(pay_difference = M_weekly - F_weekly) %>%
  top_n(1, pay_difference) %>%
  pull(Occupation)

high_wage_gap <- occupation_raw %>%
  mutate(pay_difference = M_weekly - F_weekly) %>%
  top_n(1, pay_difference) %>%
  pull(pay_difference)

# Top 10 Jobs Where Women Are Paid More Than Men
top_women_pay_difference <- occupation_raw %>%
  mutate(pay_difference = F_weekly - M_weekly) %>%
  top_n(5, pay_difference)

top_wocc_gap <- occupation_raw %>%
  mutate(pay_difference = F_weekly - M_weekly) %>%
  top_n(1, pay_difference) %>%
  pull(Occupation)

top_w_wage_gap <-  occupation_raw %>%
  mutate(pay_difference = F_weekly - M_weekly) %>%
  top_n(1, pay_difference) %>%
  pull(pay_difference)

# Top 10 highest paying jobs for men and women
occupation_mweekly <- filtered_income_df %>%
  select(Occupation, M_weekly) %>%
  filter(Occupation != "LEGAL") %>%
  top_n(10, M_weekly)

w_weekly <- filtered_income_df %>%
  select(Occupation, F_weekly) %>%
  top_n(10, F_weekly)

#Filtered occupations
occupations <- income_df %>%
  filter(Occupation %in%
           c("MANAGEMENT", "BUSINESS", "COMPUTATIONAL",
             "ENGINEERING", "SCIENCE", "LEGAL",
              "EDUCATION", "ART", "HEALTHCARE PROFESSIONAL",
              "HEALTHCARE SUPPORT", "PROTECTIVE SERVICE",
              "CULINARY", "GROUNDSKEEPING", "SERVICE",
              "SALES", "OFFICE", "AGRICULTURAL",
              "CONSTRUCTION", "MAINTENANCE", "PRODUCTION",
              "TRANSPORTATION", "SOCIAL SERVICE"))

#Number of men and women in different industries
occupations_men <- occupations %>%
  select(Occupation, M_workers)

occupations_women <- occupations %>%
  select(Occupation, F_workers)