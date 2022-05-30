library(ggplot2)
library(plotly)
library(dplyr)

source("summary.R")

income_df <- read.csv("inc_occ_gender.csv", stringsAsFactors = FALSE)

server <- function(input, output) {
  
  #tab1
  
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
        labs(title = "Top Highest Paying Occupations \n for Men",
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
        labs(title = "Top Highest Paying Occupations \n for Women",
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
        labs(title = "Top Highest Paying Occupations \n for ALL",
             x = "Occupations", y = "Median Weekly Pay") +
        theme(plot.title = element_text(face = "bold")) +
        coord_flip()
    }
    return(top_occupation)
  })
  
  #tab 3
}
