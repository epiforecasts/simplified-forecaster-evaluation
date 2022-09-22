# Load packages
library(data.table)
library(here)

# Download population data from the hub
# as available on the 1st of September 2022
population <- fread(
  "https://raw.githubusercontent.com/covid19-forecast-hub-europe/covid19-forecast-hub-europe/f6922c3e4bdcb055abcbba8e73472afacac4cf40/data-locations/locations_eu.csv" # nolint
)

fwrite(population, here("data", "population.csv"))
