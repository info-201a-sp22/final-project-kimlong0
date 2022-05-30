ggplot(data, aes(x = "",
                 y = value,
                 fill = fct_inorder(group))) +
  geom_col(width = 1, color = 1) +
  coord_polar(theta = "y") +
  scale_fill_manual(values = c("#73C6B6", "#A569BD")) +
  geom_label_repel(data = df2,
                   aes(y = pos, label = paste0(value, "%")),
                   size = 4.5, nudge_x = 1, show.legend = FALSE) +
  guides(fill = guide_legend(title = "Group")) +
  theme_void() +
  labs(title = "Percentage of Occupations Where Men Have a Higher Median Pay") +
  theme(plot.title = element_text(face = "bold")) +
  labs(title = "Percentage of Occupations Where Men Have a Higher Median Pay")

