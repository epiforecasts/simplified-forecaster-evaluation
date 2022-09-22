# Load packages
library(data.table)
library(scoringutils)
library(here)

# Load functions
source(here("R", "utils.R"))

# Load truth data
truth <- fread(here("data", "truth.csv"))

# Load population data
population <- fread(here("data", "population.csv"))

# Load forecasts
forecasts <- fread(here("data", "forecasts.csv"))

# Merge forecasts, truth, and rescale to incidence rates (per 10,000)
forecasts_with_truth <- forecasts |>
  merge_forecasts_with_truth(truth) |>
  rescale_to_incidence_rate(population, scale = 1e4)

# Load anomalies data
anomalies <- fread(here("data", "anomalies.csv")) |>
  DT(, location_name := NULL)

# Filter out anomalies from evaluation set for truth data
clean_forecasts_w_truth <- forecasts_with_truth |>
  DT(!anomalies, on = c("location", "target_end_date")) |>
  DT(, previous_end_date := forecast_date - 2) |>
  DT(!anomalies, on = c("previous_end_date" = "target_end_date", "location")) |>
  DT(, previous_end_date := NULL)

# Score forecasts
scores <- score(clean_forecasts_w_truth)

# Save forecasts
fwrite(scores, here("data", "scores.csv"))
