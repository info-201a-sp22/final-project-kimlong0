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
      
      hist(weekly_women$F_weekly,
           main = "Female Weekly Salary",
           xlab = "Average Weekly Salary",
           ylab = "Number of Occupations",
           xlim = c(0, 2500),
           col = "#A569BD",
           freq = TRUE)
    }
    else{
      weekly_both <-
        income_df %>% 
        select(Occupation, M_weekly, F_weekly)
      
      hist(weekly_both$M_weekly,
           col = "#73C6B6")
      hist(weekly_both$F_weekly,
           col = "#A569BD",
           add = TRUE)
      
    }
    
    
  return(weekly_histogram)
  })

  # tab2
  output$top_occupation_bar_chart <- renderPlot({
    
    #Function creating top plots
    create_top_occupation_plot <- function(column, type, color) {
      df <- occupation_raw %>%
        select(Occupation, column) %>%
        top_n(input$top_occupation_selection, get(column))
      
      ggplot(data = df) + 
        geom_col(mapping = aes(x = reorder(Occupation, get(column)), 
                               y = get(column)),
                 fill = color) + 
        labs(title = paste("Top Highest Paying Occupations for", type),
             x = "Occupations", y = "Median Weekly Pay") +
        theme(plot.title = element_text(face = "bold")) +
        coord_flip()
    }
    
    if (input$gender_selection == 1) {
      top_occupation <- create_top_occupation_plot("M_weekly", "Men", "#73C6B6")
    }
    else if (input$gender_selection == 2){
      top_occupation <- create_top_occupation_plot("F_weekly", "Women", "#A569BD")
    }
    else {
      top_occupation <- create_top_occupation_plot("All_weekly", "All", "red")
    }
    return(top_occupation)
  })
  
  #tab 3
  
  
  
  

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
