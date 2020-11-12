setwd("C:/Users/miqui/OneDrive/CSU Classes/Consulting/Farmers Insurance Case Study")
"https://www.fire.ca.gov/incidents"
library(readr)
library(tidyverse)
library(leaflet)
library(mapdata)
library(ggthemes)

cali <- read_csv("mapdataall.csv")
View(cali)

names(cali)

# Only want valid incidents:
cali <- cali %>%
  filter(incident_county != NaN)

# Add custom header as wanted:
cali <- cali %>% 
  mutate(popup = str_c("<strong>", incident_name, "</strong>",
                       "<br/>",
                       "County: ", incident_county,
                       "<br/>",
                       "Acres: ", incident_acres_burned,
                       "<br/>",
                       "Date Began: ", incident_date_created))

# Plot the California fire data:
leaflet(data = cali) %>%
  addMarkers(lat = ~incident_latitude, lng = ~incident_longitude, popup = ~popup) %>%
  addProviderTiles("CartoDB.DarkMatter")





"California Wildfires:"
# Add codes for DC and Puerto Rico to the default state lists
state.abb <- append(state.abb, c("DC", "PR"))
state.name <- append(state.name, c("District of Columbia", "Puerto Rico"))

# Map the state abbreviations to state names so we can join with the map data
fires$region <- map_chr(fires$STATE, function(x) { tolower(state.name[grep(x, state.abb)]) })

# Get the us state map data
county_map <- map_data('county', 'california')

# Burn time:
fires$BURN_TIME <- fires$CONT_DATE - fires$DISCOVERY_DATE



fires %>%
  filter(region == 'california') %>%
  group_by(region, subregion = tolower(FIPS_NAME)) %>%
  summarize(mean_burn_time = mean(BURN_TIME, na.rm = TRUE)) %>%
  right_join(county_map, by = c('region', 'subregion')) %>%
  ggplot(aes(x = long, y = lat, group = group, fill = mean_burn_time)) + 
  geom_polygon() + 
  geom_path(color = 'white', size = 0.1) + 
  scale_fill_continuous(low = "orange", 
                        high = "darkred",
                        name = 'Burn time (days)') + 
  theme_map() + 
  coord_map('albers', lat0=30, lat1=40) + 
  ggtitle("Average Burn Time of CA Wildfires by County 1992-2015") + 
  theme(plot.title = element_text(hjust = 0.5))



fires <- fires %>% 
  mutate(popup = str_c("<strong>", FIRE_NAME, "</strong>",
                       "<br/>",
                       "County: ", FIPS_NAME,
                       "<br/>",
                       "Acres: ", FIRE_SIZE,
                       "<br/>",
                       "Date Began: ", DISCOVERY_DATE,
                       "<br/",
                       "Duration: ", BURN_TIME))

# Plot the California fire data:
fires %>%
  filter(STATE == "CA", FIRE_YEAR == "2015") %>%
  sample_n(200) %>%
  leaflet() %>%
  addMarkers(lat = ~LATITUDE,
             lng = ~LONGITUDE,
             popup = ~popup) %>%
  addProviderTiles("CartoDB.DarkMatter")













