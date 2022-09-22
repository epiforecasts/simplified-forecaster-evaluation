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
  
# Load anomalies
anomalies <- fread(here("data", "anomalies.csv")) |>
  DT(, location_name := NULL) |>
  DT(, anomaly := TRUE)

# Tag anomalies from evaluation set for truth data
# Based on: https://github.com/covid19-forecast-hub-europe/covid19-forecast-hub-europe/blob/39823425e9ea5d66c3dc0e7a55fa7ba5433d7df2/code/evaluation/load_and_score_models.r#L29 # nolint
metadata <- anomalies |>
  copy() |>
  DT(hub_forecasts, on = c("location", "target_end_date")) |>
  DT(, previous_end_date := forecast_date - 2)

metadata <- anomalies |>
  DT(metadata,
     on = c("target_end_date" = "previous_end_date", "location")
  ) |>
  DT(, c("target_end_date", "anomaly") := NULL) |>
  setnames(
    c("i.target_end_date", "i.anomaly"), c("target_end_date", "anomaly")
  ) |>
  DT(is.na(anomaly), anomaly := FALSE) |>
  DT(, anomaly := as.logical(anomaly))

# Streamline to unqiue forecast metadata
# + count anomalies
metadata <- metadata |>
  DT(
    target %in% c("1 wk ahead inc case", "2 wk ahead inc case",
                  "3 wk ahead inc case", "4 wk ahead inc case")
  ) |>
  DT(, .(model, location, forecast_date, anomaly, target)) |>
  unique() |>
  DT(,
   `:=`(anomaly = any(anomaly), n = .N, n_anomaly = sum(anomaly)),
   by = c("location", "forecast_date", "model")
  ) |>
  DT(target %in% "1 wk ahead inc case") |>
  DT(, .(model, location, forecast_date, anomaly, n_anomaly, n)) |>
  unique()

# Save metadata
fwrite(metadata, here("data", "metadata.csv"))
