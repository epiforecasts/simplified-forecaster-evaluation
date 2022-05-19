# Load packages
library(data.table)
library(here)

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
up_to <- Sys.Date()
forecast_dates <- seq(as.Date("2022-01-15"), up_to, by = "day")

# Check
hub_forecasts <- get_hub_forecasts(
  "covid19-forecast-hub-europe/covid19-forecast-hub-europe",
  dates = forecast_dates,
  models = models
)

# Save forecasts
fwrite(hub_forecasts, "forecasts.csv")
