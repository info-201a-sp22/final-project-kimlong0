#hist
hist(m_weekly_numeric,
     main = "Male Weekly Salary",
     xlab = "Average Weekly Salary",
     ylab = "Number of Occupations",
     xlim = c(0, 2500),
     col = "#73C6B6",
     freq = TRUE)

hist(f_weekly_numeric,
     main = "Female Weekly Salary",
     xlab = "Average Weekly Salary",
     ylab = "Number of Occupations",
     xlim = c(0, 2500),
     col = "#A569BD",
     freq = TRUE)