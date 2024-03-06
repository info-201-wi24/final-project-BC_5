library(shiny)
library(leaflet)
library(bslib)
library(dplyr)
library(ggplot2)
library(leaflet)
library(stringr)
library("plotly")

combined_df <- read.csv("Charging.csv")

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Overview Tab Title",
   h1("Some title"),
   p("some explanation")
)

## VIZ 1 TAB INFO

viz_1_sidebar <- sidebarPanel(
  img(src = "Tesla.jpg"),
  h2("Pick a Date:"),
  sliderInput("date", "Select Date:",
              min = as.Date("2009-01-01"), # Set minimum date
              max = as.Date("2024-12-31"), # Set maximum date
              value = as.Date("2017-01-24"), # Set initial date
              step = 31 # Set step size (31 days)
  ),
  p("Ever since record keeping for charging stations began in 2009, charging 
    stations have only grown", em("exponetially"), " on paper. Despite this however,\
    in reality 'public' charging infrastruce has remained clustered within the 
    King county area, heavily skewing numbers while providing true 
    access to only a select few.")
)

viz_1_main_panel <- mainPanel(
  fluidRow(
    h3("Map of EV Charging Stations Over Time"),
    column(12,leafletOutput(outputId = "viz_1_map")),
    p("  "),
    h3("Charging Stations Built Over Time"),
    column(12, plotOutput("viz_1_culm_plot"))
  )
)

viz_1_tab <- tabPanel("Charging Stations Mapped",
  sidebarLayout(
    viz_1_sidebar,
    viz_1_main_panel
  )
)

## VIZ 2 TAB INFO

viz_2_sidebar <- sidebarPanel(
  h2("Options for graph"),
  checkboxGroupInput("county_checkbox", "Select Counties",
                     choices = unique(combined_df$County),
                     selected = unique(combined_df$County)[1]),
)

viz_2_main_panel <- mainPanel(
  h2("WA Counties Ev Adoption"),
  plotlyOutput(outputId = "your_viz_1_output_id")
)

viz_2_tab <- tabPanel("EV vs Gas Cars in WA",
  sidebarLayout(
    viz_2_sidebar,
    viz_2_main_panel
  )
)

## VIZ 3 TAB INFO

viz_3_sidebar <- sidebarPanel(
  h2("Options for graph"),
  checkboxGroupInput("checkbox_county", "Select Counties",
                     choices = unique(combined_df$County),
                     selected = unique(combined_df$County)[1]),
)

viz_3_main_panel <- mainPanel(
  h2("Charging Stations Vs EV Use by County"),
  plotlyOutput(outputId = "graph1"),
  plotlyOutput(outputId = "graph2")
)

viz_3_tab <- tabPanel("Charging Stations Vs EV Adoption",
  sidebarLayout(
    viz_3_sidebar,
    viz_3_main_panel
  )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion Tab Title",
 h1("Some title"),
 p("some conclusions")
)

ui <- navbarPage("The Link Between Charging Stations and EV Ownership",
  theme = bs_theme(version = 4, bootswatch = "minty"),
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)
