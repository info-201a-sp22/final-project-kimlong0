library(knitr)

# Gathering just the groups of occupations
occupations <- income_df %>%
  filter(Occupation %in%
           c("MANAGEMENT", "BUSINESS", "COMPUTATIONAL", "ENGINEERING",
             "SCIENCE", "LEGAL", "EDUCATION", "ART", "HEALTHCARE PROFESSIONAL",
             "HEALTHCARE SUPPORT", "PROTECTIVE SERVICE", "CULINARY",
             "GROUNDSKEEPING", "SERVICE", "SALES", "OFFICE", "AGRICULTURAL",
             "CONSTRUCTION", "MAINTENANCE", "PRODUCTION", "TRANSPORTATION",
             "SOCIAL SERVICE"))

# Change column names to become more readable.
colnames(occupations) <- c('Industry', 'Total Workers', 'Median Weekly Income', 'Number of Male Workers', 'Male Median Weekly Income', 'Number of Female Workers', 'Female Median Weekly Income')

# Display Table
kable(occupations)
