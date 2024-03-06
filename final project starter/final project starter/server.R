library(dplyr)
library(ggplot2)
library(leaflet)
library(stringr)

charging_stations_df <- read.csv("https://data.openei.org/files/106/alt_fuel_stations%20%28Jul%2029%202021%29.csv")

refined_charging_stations_df <- charging_stations_df %>%
  filter(Fuel.Type.Code == "ELEC" & State == "WA" & str_detect(Groups.With.Access.Code, "^Public")) %>%
  select(Station.Name, City,Longitude,Latitude,Open.Date)

# change filter date based on slider input, giving more stations on map
charging_stations_with_date <- refined_charging_stations_df %>%
  mutate(true_date =as.Date(Open.Date))

culm_stations <- charging_stations_with_date %>%
  na.omit() %>%
  group_by(true_date) %>%
  summarise(total_stations = n()) %>%
  mutate(total_stations = cumsum(total_stations))

server <- function(input, output) {
  
  output$viz_1_map <- renderLeaflet({
    # Filter the data based on the selected date
    filtered_df <- charging_stations_with_date %>%
      filter(true_date <= input$date)
    
    palette_fn <- colorFactor(palette = "Paired", domain = filtered_df[["City"]])
    
    # Create Leaflet map
    leaflet(data = filtered_df) %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lng = -122.3321, lat = 47.6062, zoom = 5.5) %>%
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
  # ggplot(culm_stations)+
  #   geom_smooth(
  #     mapping = aes(
  #       x = true_date,
  #       y=total_stations
  #     ))
    
  
}
