library(shiny)
library(leaflet)
library(bslib)


## OVERVIEW TAB INFO

overview_tab <- tabPanel("Overview Tab Title",
   h1("Some title"),
   p("some explanation")
)

## VIZ 1 TAB INFO

viz_1_sidebar <- sidebarPanel(
  h2("Pick a Date:"),
  viz_1_sidebar <- sidebarPanel(
    dateInput("date",
              "Select Date:", 
              value = "2022-01-01", 
              format = "mm/dd/yyyy",
              min =   "2015-01-01",
              max = "2024-01-01")
    )
)

viz_1_main_panel <- mainPanel(
  h2("Map of Washington"),
  leafletOutput(outputId = "viz_1_map")    
)

viz_1_tab <- tabPanel("Charging Stations Mapped",
  sidebarLayout(
    viz_1_sidebar,
    viz_1_main_panel
  )
)
# 
# ## VIZ 2 TAB INFO
# 
# viz_2_sidebar <- sidebarPanel(
#   h2("Options for graph"),
#   #TODO: Put inputs for modifying graph here
# )
# 
# viz_2_main_panel <- mainPanel(
#   h2("Vizualization 2 Title"),
#   # plotlyOutput(outputId = "your_viz_1_output_id")
# )
# 
# viz_2_tab <- tabPanel("Viz 2 tab title",
#   sidebarLayout(
#     viz_2_sidebar,
#     viz_2_main_panel
#   )
# )
# 
# ## VIZ 3 TAB INFO
# 
# viz_3_sidebar <- sidebarPanel(
#   h2("Options for graph"),
#   #TODO: Put inputs for modifying graph here
# )
# 
# viz_3_main_panel <- mainPanel(
#   h2("Vizualization 3 Title"),
#   # plotlyOutput(outputId = "your_viz_1_output_id")
# )
# 
# viz_3_tab <- tabPanel("Viz 3 tab title",
#   sidebarLayout(
#     viz_3_sidebar,
#     viz_3_main_panel
#   )
# )
# 
# ## CONCLUSIONS TAB INFO
# 
# conclusion_tab <- tabPanel("Conclusion Tab Title",
#  h1("Some title"),
#  p("some conclusions")
# )
# 
# 

ui <- navbarPage("Example Project Title",
  overview_tab,
  viz_1_tab,
  #viz_2_tab,
  #viz_3_tab,
  #conclusion_tab
)