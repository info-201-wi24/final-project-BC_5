# Delete all variables in your workspace. This will make it easier to test your script.
rm(list = ls())

##load important packages
library(dplyr)
library(stringr)
library(testthat)

#import in Charging Station data for EVs from data.gov
#https://data.openei.org/files/106/alt_fuel_stations%20%28Jul%2029%202021%29.csv
#save in variable
charging_stations_df <- read.csv("https://data.openei.org/files/106/alt_fuel_stations%20%28Jul%2029%202021%29.csv")
county_city_conversion <- read.csv("https://data.wa.gov/api/views/g2kf-7usg/rows.csv?accessType=DOWNLOAD")
ev_sales_washington <- read.csv("https://data.wa.gov/api/views/3d5d-sdqb/rows.csv?accessType=DOWNLOAD")
  
# Filter for only electric fuel type and stations in Washington
refined_charging_stations_df <- charging_stations_df %>%
  filter(Fuel.Type.Code == "ELEC" & State == "WA" & str_detect(Groups.With.Access.Code, "^Public")) %>%
  select(Station.Name, City)

# Select city and county name
county_city_conversion <- county_city_conversion %>%
  select(COUNTY.NAME, CITY.NAME) %>%
  group_by(CITY.NAME) %>%
  summarise(COUNTY.NAME = first(COUNTY.NAME)) 

# Filter for only EVs in WA and select relevant data on EVs
ev_sales_washington <- ev_sales_washington %>% 
  filter(State == "WA") %>% 
  select(County, Electric.Vehicle..EV..Total, Percent.Electric.Vehicles)

# Join with the county-city conversion to get the county
#names for each city and remove any NA values
refined_charging_stations_df <- refined_charging_stations_df %>%
  left_join(county_city_conversion, by = c("City" = "CITY.NAME")) %>%
  filter(!is.na(COUNTY.NAME))

# Now, perform the aggregation to count the number of stations per county
refined_charging_stations_df <- refined_charging_stations_df %>%
  group_by(COUNTY.NAME) %>%
  summarise(Num_EV_Stations = n(), .groups = 'drop')%>%
  filter(!is.na(Num_EV_Stations))




#join stations with EV surroudings
combined_df <- left_join(ev_sales_washington,refined_charging_stations_df, by = c( "County" = "COUNTY.NAME"))
combined_df <- distinct(combined_df, .keep_all = FALSE)

#create a summary table for findings related to charging station numbers


summary_df <- combined_df %>% 
  summarise(mean(Num_EV_Stations, na.rm = TRUE),
  median(combined_df$Num_EV_Stations,na.rm = TRUE),
  sd(Num_EV_Stations, na.rm = TRUE))
  
#create a new categorical variable tracking if a county has more chargers than the median
#of Washington state

combined_df <- combined_df %>%
  mutate(above_median = 
        Num_EV_Stations>summary_df$`median(combined_df$Num_EV_Stations, na.rm = TRUE)`
  )

#add an numerical variable that provides each county with a percentage of 
#how many charging stations they have of the total number in Washington.
total_charger_number <- sum(combined_df$Num_EV_Stations, na.rm = TRUE)


combined_df<- combined_df %>%
  mutate(percent_EV_stations= 
       Num_EV_Stations/total_charger_number*100)
         
