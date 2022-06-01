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

# Score forecasts
scores <- score(forecasts_with_truth)

# Save forecasts\
fwrite(scores, here("data", "scores.csv"))
