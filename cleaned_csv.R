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
  select(COUNTY.NAME, CITY.NAME)

# Filter for only EVs in WA and select relevant data on EVs
ev_sales_washington <- ev_sales_washington %>% 
  filter(State == "WA") %>% 
  select(County, Electric.Vehicle..EV..Total, Percent.Electric.Vehicles)

# Join with the county-city conversion to get the county names for each city and remove any NA values
refined_charging_stations_df <- refined_charging_stations_df %>%
  left_join(county_city_conversion, by = c("City" = "CITY.NAME")) %>%
  filter(!is.na(COUNTY.NAME))

# Now, perform the aggregation to count the number of stations per county
refined_charging_stations_df <- refined_charging_stations_df %>%
  group_by(COUNTY.NAME) %>%
  summarise(Num_EV_Stations = n(), .groups = 'drop')
