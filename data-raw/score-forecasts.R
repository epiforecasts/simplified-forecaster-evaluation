# Load packages
library(data.table)
library(scoringutils)
library(here)

# Load functions
source(here("R", "utils.R"))

# Load truth data
truth <- fread(here("data", "truth.csv"))

# Load forecasts
forecasts <- fread(here("data", "forecasts.csv"))

# Merge forecasts and truth
forecasts_with_truth <- merge_forecasts_with_truth(forecasts, truth)

# Score forecasts
scores <- score(forecasts_with_truth)

# Save forecasts\
fwrite(scores, here("data", "scores.csv"))
