# Load packages
library(data.table)
library(here)
library(gh)

# Load functions
source(here("R", "get-hub-forecasts.R"))

# Use memoise
start_using_memoise()

# Check out available forecasts models from the ECDC forecasting hub repo
get_hub_forecast_paths(
  "covid19-forecast-hub-europe/covid19-forecast-hub-europe"
) |>
  available_forecast_models()

# Select the simplified forecast model and the ECDC ensemble
models <- c("epiforecasts-weeklygrowth", "EuroCOVIDhub-ensemble")

# First available forecast submission was the 15th of Janurary 2022 and has
# continued each week
# We freeze data extraction on the 15th August 2022
up_to <- as.Date("2022-08-15")
forecast_dates <- seq(as.Date("2022-01-15"), up_to, by = "day")

# Get forecasts for models of interest
hub_forecasts <- get_hub_forecasts(
  "covid19-forecast-hub-europe/covid19-forecast-hub-europe",
  dates = forecast_dates,
  models = models
)

# Only keep forecasts for incident cases
hub_forecasts <- hub_forecasts[grepl("inc case", target)]

# Make horizon variable and drop target
hub_forecasts[, horizon := as.numeric(gsub(".*?([0-9]+).*", "\\1", target))]
set(hub_forecasts, j = "target", value = NULL)

# Rename for usage elsewhere
setnames(hub_forecasts, "value", "prediction")

# Save forecasts
fwrite(hub_forecasts, here("data", "forecasts.csv"))
