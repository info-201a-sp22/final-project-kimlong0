ggplot(data = top_pay_difference) +
  geom_col(mapping = aes(x = reorder(Occupation, pay_difference),
                         y = pay_difference),
           fill = "#73C6B6") + 
  labs(title = "Top 10 Jobs Where Men Are Paid \nMore Than Women", x = "Occupations", y = "Weekly Pay") + 
  theme(plot.title = element_text(face = "bold")) +
  coord_flip()

ggplot(data = top_women_pay_difference) +
  geom_col(mapping = aes(x = reorder(Occupation, pay_difference),
                         y = pay_difference),
           fill = "#A569BD") + 
  labs(title = "Jobs Where Women Are Paid More Than Men", x = "Occupations", y = "Weekly Pay") + 
  theme(plot.title = element_text(face = "bold")) +
  coord_flip()
