# Load packages
library(data.table)
library(scoringutils)
library(here)

# Load truth data
truth <- fread(here("data", "truth.csv"))

# Load forecasts
forecasts <- fread(here("data", "forecasts.csv"))

# Merge forecasts and truth
setnames(truth, "date", "target_end_date")
forecasts_with_truth <- truth[forecasts, on = c("location", "target_end_date")]

# Remove point forecasts
forecasts_with_truth <- forecasts_with_truth[!is.na(quantile)]

# Remove forecasts with no truth data
forecasts_with_truth <- forecasts_with_truth[!is.na(true_value)]

# Score forecasts
scores <- score(forecasts_with_truth)

# Save forecasts\
fwrite(scores, here("data", "scores.csv"))
