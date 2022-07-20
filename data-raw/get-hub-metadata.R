# Load packages
library(data.table)
library(here)
library(gh)

# Load functions
source(here("R", "get-hub-forecasts.R"))
source(here("R", "utils.R"))

# Load already processed forecasts and get target date range
target_forecasts <- fread(here("data", "forecasts.csv"))

forecast_dates <- target_forecasts |>
  DT(, forecast_date) |>
  unique()

# Use memoise
start_using_memoise()

# Get forecasts for models of interest
hub_forecasts <- get_hub_forecasts(
  "covid19-forecast-hub-europe/covid19-forecast-hub-europe",
  dates = forecast_dates
)

# Only keep forecasts for incident cases
hub_forecasts <- hub_forecasts[grepl("inc case", target)]

# Drop the Hub ensemble
hub_forecasts <- hub_forecasts |>
  DT(!model %in% "EuroCOVIDhub-ensemble")
  
# Streamline to metadata
metadata <- hub_forecasts |>
  DT(target %in% "1 wk ahead inc case") |>
  DT(, .(model, location, forecast_date, target_end_date)) |>
  unique()

# Save metadata
fwrite(metadata, here("data", "metadata.csv"))
