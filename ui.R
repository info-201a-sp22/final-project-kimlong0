library(plotly)
library(bslib)
library(markdown)

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

# Home page tab
intro_tab <- tabPanel(
  # Title of tab
  "Introduction",
  fluidPage(
    h1("Introduction"),
    p("Cow goes MOOOOOOOOOOOOOO")
  )
)

# Create sidebar panel for widget
sidebar_panel_widget_tab1 <- sidebarPanel(
  checkboxGroupInput(
    inputId = "selection",
    label = "Selection",
    choices = c("selection1", "selection2", "selection2"),
    # True allows you to select multiple choices...
    #multiple = TRUE,
    selected = "selection1"
  ),
  
  sliderInput(inputId = "slider2",
              label = h3("1-10"),
              min = min(1), 
              max = max(10),
              value = c(1, 10))
)

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
)

main_panel_plot_2 <- mainPanel(
  # Make plot interactive
  plotOutput(outputId = "top_occupation_bar_chart")
)

tab1 <- tabPanel(
  "Chart 1",
  sidebarLayout(
    sidebar_panel_widget_tab1,
    main_panel_plot
  )
)

tab2 <- tabPanel(
  "Top Occupations",
  sidebar_panel_widget_tab2,
  main_panel_plot_2
)

tab3 <- tabPanel(
  "Chart 3"
)

conclusion_tab <- tabPanel(
  "Conclusion"
)

ui <- navbarPage(
  # Select Theme
  theme = "cerulean",
  # Home page title
  "Gender Wage Gap 2015",
  intro_tab,
  tab1,
  tab2,
  tab3,
  conclusion_tab,
)
