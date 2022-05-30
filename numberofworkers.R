ggplot(data = occupations_men) +
  geom_col(mapping = aes(x = reorder(Occupation, M_workers), y = M_workers)) +
  labs(title = "Number of Male Workers in Different Industries",
       x = "Occupations", y = "Male Workers") +
  coord_flip()

ggplot(data = occupations_women) +
  geom_col(mapping = aes(x = reorder(Occupation, +F_workers), y = F_workers)) +
  labs(title = "Number of Female Workers in Different Industries",
       x = "Occupations", y = "Female Workers") +
  coord_flip()