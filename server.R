library(ggplot2)
library(plotly)
library(dplyr)
source("summary.R")

income_df <- read.csv("inc_occ_gender.csv", stringsAsFactors = FALSE)

server <- function(input, output) {
  
  #tab1
  all_weekly_numeric <- as.numeric(income_df %>% pull(All_weekly))
  m_weekly_numeric <- as.numeric(income_df %>% pull(M_weekly))
  f_weekly_numeric <- as.numeric(income_df %>% pull(F_weekly))

  income_df <- income_df %>% mutate(All_weekly = all_weekly_numeric,
                                    M_weekly = m_weekly_numeric, F_weekly = f_weekly_numeric)
  
  
  output$weekly_histogram <- renderPlot({
    if(input$genderselect == "M_weekly") {
      weekly_men <- income_df %>% 
        select(Occupation, M_weekly)
     
    weekly_histogram <- 
      hist(weekly_men$M_weekly,
           main = "Weekly Salary of Men",
           xlab = "Average Weekly Salary",
           ylab = "Number of Occupations",
           xlim = c(0, 2500),
           col = "#73C6B6",
           freq = TRUE)
    }
    else if(input$genderselect == "F_weekly") {
      weekly_women <- income_df %>% 
        select(Occupation, F_weekly)
      
      weekly_histogram <- 
        hist(weekly_women$F_weekly,
           main = "Weekly Salary of Women",
           xlab = "Average Weekly Salary",
           ylab = "Number of Occupations",
           xlim = c(0, 2500),
           col = "#A569BD",
           freq = TRUE)
    }
    else {
      weekly_both <-
        income_df %>% 
        select(Occupation, M_weekly, F_weekly)
      
      weekly_histogram <- 
        hist(weekly_both$M_weekly,
           col = "#73C6B6",
           xlab = "Average Weekly Salary",
           ylab = "Number of Occupations",
           main = "Weekly Salaries of Both")
        hist(weekly_both$F_weekly,
           col = "#A569BD",
           add = TRUE)
    }
    
    
  return(weekly_histogram)
  })

  # tab2
  output$top_occupation_bar_chart <- renderPlotly({
    
    #Function for creating plot
    create_top_occupation_plot <- function(column, type, color, order) {
      df <- occupation_raw %>%
        select(Occupation, column) %>%
        top_n(as.numeric(paste0(order, input$top_occupation_selection), get(column)))
      
      if (isTRUE(order == "+")) {
        create_occupation_plot_top(df, column, type, color)
      }
      else {
        create_occupation_plot_bottom(df, column, type, color)
      }
    }
    
    #Function creating plot descending order
    create_occupation_plot_top <- function(df, column, type, color) {
      ggplot(data = df) + 
        geom_col(mapping = aes(x = reorder(Occupation, get(column)), 
                               y = get(column), text = paste0("Median Weekly Pay: $", get(column))),
                 fill = color) + 
        labs(title = paste("Highest Paying Occupations for", type),
             x = "Occupations", y = "Median Weekly Pay (USD)") +
        theme(plot.title = element_text(face = "bold", hjust = 0.5)) +
        coord_flip()
    }
    
    #Function creating plot ascending order
    create_occupation_plot_bottom <- function(df, column, type, color) {
      ggplot(data = df) + 
        geom_col(mapping = aes(x = reorder(Occupation, -get(column)), 
                               y = get(column),
                               text = paste0("Median Weekly Pay: $", get(column))),
                 fill = color) + 
        labs(title = paste("Lowest Paying Occupations for", type),
             x = "Occupations", y = "Median Weekly Pay (USD)") +
        theme(plot.title = element_text(face = "bold", hjust = 0.5)) +
        coord_flip()
    }
    
    order <- input$order
    
    if (input$gender_selection == 1) {
      top_occupation <- create_top_occupation_plot("M_weekly", "Men", "#73C6B6", order)
    }
    else if (input$gender_selection == 2){
      top_occupation <- create_top_occupation_plot("F_weekly", "Women", "#A569BD", order)
    }
    else {
      top_occupation <- create_top_occupation_plot("All_weekly", "All", "#efbb81", order)
    }
    interactive_plots <- ggplotly(top_occupation, tooltip = "text")
  })
  
  #tab 3
  output$pay_difference <- renderPlotly({
    
    selected_difference_filtered <- occupation_difference %>% filter(Occupation %in% input$occupation_selection)
    
    top_pay_diff_plot <- ggplot(data = selected_difference_filtered) +
      geom_col(mapping = aes(x = reorder(Occupation, pay_difference),
                             y = pay_difference,
                             text = paste0("Median Pay Difference: $", pay_difference)),
               fill = "#73C6B6") + 
      labs(title = "Difference in Weekly Pay (Men - Women)",
           x = "Occupations",
           y = "Difference in Weekly Pay") + 
      theme(plot.title = element_text(face = "bold", hjust = 0.5)) +
      coord_flip()
    
    top_pay_diff_plot <- ggplotly(top_pay_diff_plot, tooltip = "text")
    return(top_pay_diff_plot)
  })
  
  output$top10male <- renderTable({
    top10male <- top_pay_difference %>% select(Occupation, pay_difference)
    top10male <- top10male %>% arrange(desc(pay_difference))
    colnames(top10male) <- c("Occupation", "Median Pay Difference (Men - Women)")
    return(top10male)
  })

  output$topfemale <- renderTable({
    topfemale <- top_women_pay_difference %>% select(Occupation, pay_difference)
    topfemale <- topfemale %>% arrange(pay_difference)
    colnames(topfemale) <- c("Occupation", "Median Pay Difference (Women - Men)")
    return(topfemale)
  })
  
  
# conclusion
  output$occupations <- renderTable({
    occupations <- occupations %>% arrange(desc(All_workers))
    
    colnames(occupations) <- c('Industry', 'Total Workers', 'Median Weekly Income', 'Number of Male Workers', 'Male Median Weekly Income', 'Number of Female Workers', 'Female Median Weekly Income')
    return(occupations)
  })
}
