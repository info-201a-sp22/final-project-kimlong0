library(plotly)
library(bslib)
library(markdown)
source("summary.R")

# Load climate data
income_df <- read.csv("inc_occ_gender.csv", stringsAsFactors = FALSE)

# Manually Determine a BootSwatch Theme
my_theme <- bs_theme(bg = "#8fcfdf", 
                     fg = "#505B5A",
                     primary = "#b5e3d5", 
                     base_font = font_google("Montserrat") 
)

my_theme <- bs_theme_update(my_theme, bootswatch = "litera") %>% 
  bs_add_rules(sass::sass_file("final_project.scss"))


# introduction page
intro_tab <- tabPanel(
  "Introduction",
  h1("Introduction", style = "color: #ed8674;"),
  fluidPage(
    includeMarkdown("intro.md")
  )
)


# Create sidebar panel for widget
sidebar_panel_widget_tab1 <- sidebarPanel(
  radioButtons("genderselect",
               label = h4("Group Selection"),
               choices = list("Men" = "M_weekly",
                              "Women" = "F_weekly",
                              "Both"))
)

sidebar_panel_widget_tab3 <- sidebarPanel(
  selectInput(
    inputId = "occupation_selection",
    label = h4("Select Occupation"),
    choices = occupation_difference$Occupation,
    multiple = TRUE,
    selected = "Lawyers"
  )
)

main_panel_plot <- mainPanel(
  plotOutput(outputId = "weekly_histogram")
)

widget_row_tab2 <- fluidRow(
  column(4,
         radioButtons("order",
                      label = h4("Order Selection"),
                         choices = list("Highest Paying Occupation" = "+",
                                        "Lowest Paying Occupation" = "-"))),
  column(4,
         radioButtons("gender_selection", label = h4("Group Selection"),
                           choices = list("Men" = 1, "Women" = 2, "All" = 3), 
                           selected = 1)),
  column(4,
         sliderInput("top_occupation_selection",
                     label = h4("Range of Occupation"), min = 1,
                     max = 25, value = 10))
)

table_title_row_tab3 <- fluidRow(
  column(6, h4("Top 10 Occupations Where Men Are Paid More Than Women")),
  column(6, h4("Only 5 Occupations Where Women Are Paid More Than Men")),
)

tablerow_tab3 <- fluidRow(
  column(6, tableOutput(outputId = "top10male")),
  column(6, tableOutput(outputId = "topfemale")),
)


main_plot_tab2 <- fluidRow(
  plotlyOutput(outputId = "top_occupation_bar_chart")
)

main_panel_plot_tab3 <- mainPanel(
  tableOutput(outputId = "top10male")
)

main_panel_plot_tab3_1 <- mainPanel(
  plotlyOutput(outputId = "pay_difference")
)

# page 1 
tab1 <- tabPanel(
  "Weekly Salary",
  h1("Weekly Salary", style = "color: #ed8674;"),
  p("In these set of graphs, one is able to examine the difference,
      between men and women, and the spread of their weekly income."),
  sidebarLayout(
    sidebar_panel_widget_tab1,
    main_panel_plot
  )
)

# page 2 
tab2 <- tabPanel(
  "Top Occupations",
  h1("Top Occupations", style = "color: #ed8674;"),
  p("The next chart chosen is a bar chart that shows the top 10 highest
    paying occupations between both male and females. A bar chart is used
    because we are looking at one category, which is occupation, and the
    weekly pay. These bar charts express the similarities and the differences
    in the top jobs for male and females. It also shows how despite comparing
    the same occupations, the jobs where women earn the most vary from the jobs
    where men earn the most."),
   fluidPage(
    widget_row_tab2,
    main_plot_tab2
  )
)

# page 3
tab3 <- tabPanel(
  "Pay Difference",
  h1("Pay Difference", style = "color: #ed8674;"), 
  p("In this interactive map, one is able to explore the different jobs, and
    compare the jobs they desire, and the pay difference between men and women
    in each of those fields."),
  sidebarLayout(
    sidebar_panel_widget_tab3,
    main_panel_plot_tab3_1),
  fluidPage(
    table_title_row_tab3,
    tablerow_tab3
  )
)

# Conclusion page
conclusion_tab <- tabPanel(
  "Conclusion",
  h1("Conclusion", style = "color: #ed8674;"),
  fluidPage(
    includeMarkdown("conclusion.md")
    ),
  fluidRow(
    tableOutput("occupations")
  )
)

ui <- navbarPage(
  theme = my_theme,
  "Gender Wage Gap in 2015",
  intro_tab,
  tab1,
  tab2,
  tab3,
  conclusion_tab,
)
