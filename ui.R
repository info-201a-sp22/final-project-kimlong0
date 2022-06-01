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
  radioButtons("genderselect",
               label = h3("Selection"),
               choices = list("Men" = "M_weekly",
                              "Women" = "F_weekly",
                              "Both"))
  )
  # checkboxGroupInput(
  #   inputId = "genderselect",
  #   label = h3("Selection"),
  #   choices = c("Men" = "M_weekly", "Women" = "F_weekly", "Both"),
  #   selected = "M_weekly"


main_panel_plot <- mainPanel(
  # Make plot interactive
  #plotlyOutput(outputId = "climate_plot")
  plotOutput(outputId = "weekly_histogram")
)

widget_row_tab2 <- fluidRow(
  column(4,
         radioButtons("order",
                      label = h3("Order Selection"),
                         choices = list("Highest Paying Occupation" = "+",
                                        "Lowest Paying Occupation" = "-"))),
  column(4,
         radioButtons("gender_selection", label = h3("Group Selection"),
                           choices = list("Men" = 1, "Women" = 2, "All" = 3), 
                           selected = 1)),
  column(4,
         sliderInput("top_occupation_selection",
                     label = h3("Range of Occupation"), min = 1,
                     max = nrow(occupation_raw), value = 10))
)

main_plot_tab2 <- fluidRow(
  plotlyOutput(outputId = "top_occupation_bar_chart")
)

main_panel_plot_tab3 <- mainPanel(
  fluidPage(
    plotOutput(outputId = "top_pay_diff_tab3")
  ))

tab3 <- tabPanel(
  "woo", 
  sidebarLayout(
    main_panel_plot_tab3
  )
)

# page 1 
tab1 <- tabPanel(
  "Weekly Salary",
  sidebarLayout(
    sidebar_panel_widget_tab1,
    main_panel_plot
  )
)

# page 2 
tab2 <- tabPanel(
  "Top Occupations",
  fluidPage(
    widget_row_tab2,
    main_plot_tab2
  )
)

# page 3


# tab3 <- tabPanel(
#   "Chart 3"
# )

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
