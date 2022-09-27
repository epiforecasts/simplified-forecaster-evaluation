# Load packages
library(data.table)
library(scoringutils)
library(here)
library(lubridate)

# Load functions
source(here("R", "utils.R"))

# Load truth data
truth <- fread(here("data", "truth.csv"))

# Load population data
population <- fread(here("data", "population.csv")) |>
  DT(, location_name := NULL)

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
# Based on: https://github.com/covid19-forecast-hub-europe/covid19-forecast-hub-europe/blob/39823425e9ea5d66c3dc0e7a55fa7ba5433d7df2/code/evaluation/load_and_score_models.r#L29 # nolint
clean_forecasts_w_truth <- forecasts_with_truth |>
  DT(!anomalies, on = c("location", "target_end_date")) |>
  DT(,
    previous_end_date := ceiling_date(
      forecast_date - 4, week_start = 6, unit = "week"
    )
  ) |>
  DT(!anomalies, on = c("previous_end_date" = "target_end_date", "location")) |>
  DT(, previous_end_date := NULL)

# Check forecasts to be scored
check_forecasts(clean_forecasts_w_truth)

# Save forecasts to be scored
fwrite(clean_forecasts_w_truth, here("data", "forecasts_ready_for_scoring.csv"))

# Score forecasts
scores <- clean_forecasts_w_truth |>
  score()

# Save forecasts
fwrite(scores, here("data", "scores.csv"))
