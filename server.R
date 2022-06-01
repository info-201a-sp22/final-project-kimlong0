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
           main = "Male Weekly Salary",
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
           main = "Female Weekly Salary",
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
           main = "Histogram for Both Men and Women")
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
                               y = get(column), text = paste0("Median Weekly Pay $", get(column))),
                 fill = color) + 
        labs(title = paste("Highest Paying Occupations for", type),
             x = "Occupations", y = "Median Weekly Pay (USD)") +
        theme(plot.title = element_text(face = "bold")) +
        coord_flip()
    }
    
    #Function creating plot ascending order
    create_occupation_plot_bottom <- function(df, column, type, color) {
      ggplot(data = df) + 
        geom_col(mapping = aes(x = reorder(Occupation, -get(column)), 
                               y = get(column),
                               text = paste0("Median Weekly Pay $", get(column))),
                 fill = color) + 
        labs(title = paste("Lowest Paying Occupations for", type),
             x = "Occupations", y = "Median Weekly Pay (USD)") +
        theme(plot.title = element_text(face = "bold")) +
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
      top_occupation <- create_top_occupation_plot("All_weekly", "All", "red", order)
    }
    return(top_occupation)
  })
  
  #tab 3
  
  output$top_pay_diff_tab3 <- renderPlot({
    top_pay_diff_plot <- ggplot(data = top_pay_difference) +
      geom_col(mapping = aes(x = reorder(Occupation, pay_difference),
                             y = pay_difference),
               fill = "#73C6B6") + 
      labs(title = "Top 10 Jobs Where Men Are Paid \nMore Than Women", x = "Occupations", y = "Weekly Pay") + 
      theme(plot.title = element_text(face = "bold")) +
      coord_flip()
    return(top_pay_diff_plot)
  })
  
  
  
  

# conclusion
  output$occupations <- renderTable({
    occupations <- income_df %>%
      filter(Occupation %in%
               c("MANAGEMENT", "BUSINESS", "COMPUTATIONAL", "ENGINEERING",
                 "SCIENCE", "LEGAL", "EDUCATION", "ART", "HEALTHCARE PROFESSIONAL",
                 "HEALTHCARE SUPPORT", "PROTECTIVE SERVICE", "CULINARY",
                 "GROUNDSKEEPING", "SERVICE", "SALES", "OFFICE", "AGRICULTURAL",
                 "CONSTRUCTION", "MAINTENANCE", "PRODUCTION", "TRANSPORTATION",
                 "SOCIAL SERVICE"))
  })
  return(occupations)


}
