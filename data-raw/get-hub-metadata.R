# Load packages
library(data.table)
library(here)
library(gh)

# Load functions
source(here("R", "get-hub-forecasts.R"))

# Use memoise
start_using_memoise()

# First available forecast submission was the 15th of Janurary 2022 and has
# continued each week
up_to <- Sys.Date()
forecast_dates <- seq(as.Date("2022-01-15"), up_to, by = "day")

# Get all forecasts in this period
hub_forecasts <- get_hub_forecasts(
  "covid19-forecast-hub-europe/covid19-forecast-hub-europe",
  dates = forecast_dates
)

# Only keep forecasts for incident cases
hub_forecasts <- hub_forecasts[grepl("inc case", target)]

# Save forecasts
fwrite(hub_forecasts, here("data", "forecasts.csv"))
