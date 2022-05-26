# Load packages
library(data.table)
library(here)

# Download population data from the hub
population <- fread(
  "https://raw.githubusercontent.com/covid19-forecast-hub-europe/covid19-forecast-hub-europe/main/data-locations/locations_eu.csv" # nolint
)

fwrite(population, here("data", "population.csv"))
