library(ggplot2)
library(plotly)
library(dplyr)
source("summary.R")

income_df <- read.csv("inc_occ_gender.csv", stringsAsFactors = FALSE)

server <- function(input, output) {
  
  #tab1
  weeklys <- income_df %>% 
    select(Occupation, M_weekly, F_weekly)
  
  weekly_incomes <- weeklys %>% 
    pivot_longer(!c(Occupation), 
                 names_to = "category",
                 values_to = "amount")

  
  output$weekly_histogram <- renderPlot({
    filter_data <- weekly_incomes %>%
      filter(category %in% input$genderselect)
    
    weekly_historgram <- 
      hist(amount,
           xlab = "Average Weekly Salary",
           ylab = "Number of Occupations",
           col = "#73C6B6")
    
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
