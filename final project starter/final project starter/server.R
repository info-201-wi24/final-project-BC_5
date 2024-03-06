library("plotly")

server <- function(input, output, session){
  
  # TODO Make outputs based on the UI inputs here
  combined_df <- read.csv("https://raw.githubusercontent.com/info-201-wi24/final-project-BC_5/main/Charging.csv") 
  
  filtered_data <- reactive({
    select_counties <- input$county_checkbox
    combined_df %>%
      filter(County %in% select_counties)
  })

  output$your_viz_1_output_id <- renderPlotly({
    plot_ly(data = filtered_data(), x = ~County, y = ~EVs_in_County/Non_EVs_in_county, type = "bar",
            marker = list(color = "green")) %>%
      layout(title = "EV Adoption vs Gas Cars Across WA Counties",
             xaxis = list(title = "County"),
             yaxis = list(title = "EVs/NonEVS"))
  })
  
  graph2Data <- reactive({
    select_county <- input$checkbox_county
    combined_df %>%
      filter(County %in% select_county)
  })
  
  output$graph1 <- renderPlotly({
    plot_ly(data = graph2Data(), x = ~County, y = ~Num_EV_Stations, type = "bar",
            marker = list(color = "orange")) %>% 
      layout(title = "Number of EV Stations in a county",
             xaxis = list(title = "County"),
             yaxis = list(title = "Number of EV Stations"))
  })
  
  output$graph2 <- renderPlotly({
    plot_ly(data = graph2Data(), x = ~County, y = ~EVs_in_County, type = "bar",
            marker = list(color = "blue")) %>% 
      layout(title = "EV adoption by County",
             xaxis = list(title = "County"),
             yaxis = list(title = "Evs In County"))
  })
}