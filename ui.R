library(plotly)
library(bslib)
library(markdown)
source("summary.R")

# Load climate data
income_df <- read.csv("inc_occ_gender.csv", stringsAsFactors = FALSE)

# Manually Determine a BootSwatch Theme
# my_theme <- bs_theme(bg = "#0b3d91", #background color
#                   fg = "white", #foreground color
#                   primary = "#FCC780", # primary color
# ) 

# Update BootSwatch Theme
# my_theme <- bs_theme_update(my_theme, bootswatch = "cerulean") %>% 
#   # Add custom styling from a scss file
#   bs_add_rules(sass::sass_file("my_style.scss"))


# introduction page
intro_tab <- tabPanel(
  "Introduction",
  fluidPage(
    includeMarkdown("intro.md")
  )
)


# Create sidebar panel for widget
sidebar_panel_widget_tab1 <- sidebarPanel(
  checkboxGroupInput(
    inputId = "genderselect",
    label = h3("Selection"),
    choices = c("M_weekly" = "Men", "F_weekly" = "Women")
))
  

sidebar_panel_widget_tab2 <- sidebarPanel(
  radioButtons("gender_selection", label = h3("Selection"),
               choices = list("Men" = 1, "Women" = 2, "All" = 3), 
               selected = 1),
  sliderInput("top_occupation_selection", label = h3("Number of Top Occupation"), min = 1, 
              max = nrow(occupation_raw), value = 10)
)

main_panel_plot <- mainPanel(
  # Make plot interactive
  #plotlyOutput(outputId = "climate_plot")
  plotOutput(outputId = "weekly_histogram")
)

main_panel_plot_2 <- mainPanel(
  # Make plot interactive
  plotOutput(outputId = "top_occupation_bar_chart")
)

# page 1 
tab1 <- tabPanel(
  "Chart 1",
  sidebarLayout(
    sidebar_panel_widget_tab1,
    main_panel_plot
  )
)


# page 2 
tab2 <- tabPanel(
  "Top Occupations",
  sidebar_panel_widget_tab2,
  main_panel_plot_2
)

# page 3
tab3 <- tabPanel(
  "Chart 3"
)

# Conclusion page
conclusion_tab <- tabPanel(
  "Conclusion",
  fluidPage(
    includeMarkdown("conclusion.md"),
    mainPanel(
      tableOutput("occupations")
    )
  )
)


ui <- navbarPage(
  # Select Theme
  theme = "cerulean",
  # Home page title
  "Gender Wage Gap in 2015",
  intro_tab,
  tab1,
  tab2,
  tab3,
  conclusion_tab,
)
