library(dplyr)
library(ggplot2)
library(leaflet)
library(stringr)
library("plotly")

charging_stations_df <- read.csv("https://data.openei.org/files/106/alt_fuel_stations%20%28Jul%2029%202021%29.csv")

refined_charging_stations_df <- charging_stations_df %>%
  filter(Fuel.Type.Code == "ELEC" & State == "WA" & str_detect(Groups.With.Access.Code, "^Public")) %>%
  select(Station.Name, City,Longitude,Latitude,Open.Date)

# change filter date based on slider input, giving more stations on map
charging_stations_with_date <- refined_charging_stations_df %>%
  mutate(true_date =as.Date(Open.Date))

culm_stations <- charging_stations_with_date %>%
  group_by(true_date) %>%
  summarise(total_stations = n()) %>%
  mutate(total_stations = cumsum(total_stations))

# TODO Make outputs based on the UI inputs here
combined_df <- read.csv("https://raw.githubusercontent.com/info-201-wi24/final-project-BC_5/main/Charging.csv")

server <- function(input, output, session){
  # Tab 1.
  output$viz_1_map <- renderLeaflet({
    # Filter the data based on the selected date
    filtered_df <- charging_stations_with_date %>%
      filter(true_date <= input$date)
    
    palette_fn <- colorFactor(palette = "Paired", domain = filtered_df[["City"]])
    
    # Create Leaflet map
    leaflet(data = filtered_df) %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lng = -122.3321, lat = 47.6062, zoom = 8) %>%
      addCircles(
        lat = ~Latitude, # specify the column for `lat` as a formula
        lng = ~Longitude, # specify the column for `lng` as a formula
        stroke = FALSE, # remove border from each circle
        radius = 50,
        fillOpacity = 1,
        label = ~Station.Name,
        color = ~palette_fn(filtered_df[["City"]]) #Color stations by their city.
      )
  })
  
  output$viz_1_culm_plot <- renderPlot({
  ggplot(culm_stations)+
        geom_smooth(
          mapping = aes(
            x = true_date,
            y=total_stations,
            text = total_stations
          ))+
        labs(
          y = "Total Stations",
          x = "Date",
          title = "# of Stations Over Time"
        )
  })

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
