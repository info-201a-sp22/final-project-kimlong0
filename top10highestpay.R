

#Plot for top 10 highest paying jobs for men 
ggplot(data = occupation_mweekly) + 
  geom_col(mapping = aes(x = reorder(Occupation, M_weekly), 
                         y = M_weekly), 
           fill = "#73C6B6") +
  labs(title = "Top 10 Highest Paying Occupations \n for Men", x = "Occupations", y = "Weekly Pay") + 
  theme(plot.title = element_text(face = "bold")) +
  coord_flip()

ggplot(data = w_weekly) + 
  geom_col(mapping = aes(x = reorder(Occupation, F_weekly), 
                         y = F_weekly),
           fill = "#A569BD") + 
  labs(title = "Top 10 Highest Paying Occupations \n for Women", x = "Occupations", y = "Weekly Pay") +
  theme(plot.title = element_text(face = "bold")) +
  coord_flip()


