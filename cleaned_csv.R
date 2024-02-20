

# Delete all variables in your workspace. This will make it easier to test your script.
rm(list = ls())

##load important packages
library(dplyr)
library(stringr)
library(testthat)




#import in Charging Station data for EVs from data.gov
#https://data.openei.org/files/106/alt_fuel_stations%20%28Jul%2029%202021%29.csv
#save in variable
charge_station_df <- read.csv("https://data.openei.org/files/106/alt_fuel_stations%20%28Jul%2029%202021%29.csv")

#saving the location of cities and their respective counties in Washington
county_city_conversion <- read.csv("https://data.wa.gov/api/views/g2kf-7usg/rows.csv?accessType=DOWNLOAD")

#import in EV sales in Washington 
ev_sales_washington <- read.csv("https://data.wa.gov/api/views/3d5d-sdqb/rows.csv?accessType=DOWNLOAD")

#trimming dataframe to only include stations in Washington, and of those, only eletric.
charge_station_df <- charge_station_df %>%
  filter(State == "WA")%>%
  filter(Fuel.Type.Code == "ELEC")%>%
  select(Fuel.Type.Code,City,Open.Date,EV.On.Site.Renewable.Source,Restricted.Access)
#trimming dataframe to vehicles licenced in Washington, 
#and getting the most up to date data possible 
ev_sales_washington <-ev_sales_washington%>%
  filter(State == "WA")%>%
  filter(Date =="December 31 2023")
  

#joining charging stations by city into counties
charge_station_county <- left_join(charge_station_df,county_city_conversion, by=c("City"="CITY.NAME"))

#joining EV sales, and charging station locatons
combined_df <- left_join(ev_sales_washington,charge_station_county,by=c("County"="COUNTY.NAME"))
combined_df<- distinct(combined_df,.keep_all = TRUE)