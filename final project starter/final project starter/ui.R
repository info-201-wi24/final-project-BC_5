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

overview_tab <- tabPanel("Overview",
   h1("EVs and Adoption"),
   p("Electric vehicles (EVs) have recently emerged recently aimed to address the environmental impacts of using fossil fuels for transportation. 
      To understand the adoption rate and the factors influencing consumers' decision to switch to EVs as their primary mode of transportation, 
      we analyzed datasets on EV charging station availability in the US and Canada provided by the Alternative Fuel Data Center, 
      as well as data on EV registrations in the state of Washington collected by the Washington Department of Transportation. 
      One notable limitation of our study is that the dataset from the Alternative Fuel Data Center is 3 years old. 
      This could be particularly outdated for rapidly evolving urban areas like King County, 
      which has seen significant investment and population growth. Consequently, 
      the actual number of EV registrations and charging stations could be considerably higher now than it was three years ago."),
   h2("Link to Alternative Fuel Data Center Dataset on EV Charging Stations"),
   a("EV Charging Stations Dataset", href = "https://catalog.data.gov/dataset/alternative-fueling-station-locations-422f2", target = "_blank"),
   h2("Link to Washington's Department of Transportation Dataset on EV Charging Stations"),
   a("Washington's Department of Transportation Dataset", href = "https://catalog.data.gov/dataset/electric-vehicle-population-size-history-by-county", target = "_blank")
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

conclusion_tab <- tabPanel("Conclusion",
 h1("Major Takeaways"),
 tags$ul(
   tags$li("Adoption Rate and Infrastructure Growth",
           tags$p("The rate at which electric vehicles (EVs) are adopted is profoundly influenced by the presence and accessibility of charging infrastructure. 
                  A clear pattern emerges when examining counties with higher numbers of charging stations; these regions, 
                  such as Chelan and Clallam, report significantly higher percentages of EVs. 
                  This trend firmly establishes the critical role that infrastructure development plays in facilitating the adoption of electric vehicles.")),
   tags$li("Geographical Variability in EV Adoption",
           tags$p("The data reveals considerable differences in EV adoption rates across various counties, 
                  highlighting the influence of socio-economic factors, urban versus rural distinctions, 
                  and the impact of local governmental policies designed to promote EV usage. 
                  Urban areas, often characterized by a denser concentration of charging stations and more aggressive environmental policies, 
                  show a marked increase in EV adoption compared to rural regions. 
                  This disparity suggests that geographical location plays a significant role in determining the likelihood of EV adoption within a community.")),
   tags$li("Exponential Growth in EV Adoption",
           tags$p("The dataset spanning from 2009 to 2024 illustrates a remarkable, 
           nearly exponential increase in electric vehicle (EV) adoption in Washington State, 
           indicating a strong and growing consumer shift towards electric mobility. 
           This upward trend is observed regardless of the pace of infrastructure development or the geographical location of counties, 
           highlighting a broader acceptance and enthusiasm for EVs among the population. 
           The steady and significant growth in electric vehicles registrations over the years reflects increasing environmental awareness, 
           improvements in EV technology, and the decreasing total cost of ownership of EVs. 
           This trend shows consumer motivation for a cleaner, more sustainable transportation options."))
 )
)

ui <- navbarPage("The Link Between Charging Stations and EV Ownership",
  theme = bs_theme(version = 4, bootswatch = "minty"),
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)
