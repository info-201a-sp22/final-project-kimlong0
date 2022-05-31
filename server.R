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
    if (input$gender_selection == 1) {
      # Top highest paying jobs for men
      occupation_mweekly <- occupation_raw %>%
        select(Occupation, M_weekly) %>%
        top_n(input$top_occupation_selection, M_weekly)
      
      #Plot for top highest paying jobs for men 
      top_occupation <- ggplot(data = occupation_mweekly) + 
        geom_col(mapping = aes(x = reorder(Occupation, M_weekly), 
                               y = M_weekly),
                 fill = "#73C6B6") +
        labs(title = "Top Highest Paying Occupations for Men",
             x = "Occupations", y = "Median Weekly Pay") + 
        theme(plot.title = element_text(face = "bold")) +
        coord_flip()
    }
    else if (input$gender_selection == 2){
      # Top highest paying jobs for women
      w_weekly <- occupation_raw %>%
        select(Occupation, F_weekly) %>%
        top_n(input$top_occupation_selection, F_weekly)
      
      #Plot for top highest paying jobs for women 
      top_occupation <- ggplot(data = w_weekly) + 
        geom_col(mapping = aes(x = reorder(Occupation, F_weekly), 
                               y = F_weekly),
                 fill = "#A569BD") + 
        labs(title = "Top Highest Paying Occupations for Women",
             x = "Occupations", y = "Median Weekly Pay") +
        theme(plot.title = element_text(face = "bold")) +
        coord_flip()
    }
    else {
      # Top highest paying jobs for All
      all_weekly <- occupation_raw %>%
        select(Occupation, All_weekly) %>%
        top_n(input$top_occupation_selection, All_weekly)
      
      #Plot for top highest paying jobs for All
      #Need to change color
      top_occupation <- ggplot(data = all_weekly) + 
        geom_col(mapping = aes(x = reorder(Occupation, All_weekly), 
                               y = All_weekly),
                 fill = "blue") + 
        labs(title = "Top Highest Paying Occupations for ALL",
             x = "Occupations", y = "Median Weekly Pay") +
        theme(plot.title = element_text(face = "bold")) +
        coord_flip()
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
