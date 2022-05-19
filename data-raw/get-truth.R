# Load packages
library(data.table)
library(here)

# Download JHU data from the hub
jhu <- fread(
  "https://raw.githubusercontent.com/covid19-forecast-hub-europe/covid19-forecast-hub-europe/main/data-truth/JHU/truth_JHU-Incident%20Cases.csv" # nolint
)

# Format date
jhu[, date := as.Date(date)]

# Order data by date and location
setkey(jhu, location_name, date)

# Summarise to weekly cases starting on Saturday to Sync with the forecast hubs
truth <- copy(jhu)[, truth := frollsum(value, n = 7), by = c("location_name")]

# Filter from the 15th of January 2022 to keep only observations with forecasts
truth <- truth[date >= as.Date("2022-01-15")]
truth <- truth[weekdays(date) %in% "Saturday"]

# Drop unnecessary columns
set(truth, j = c("value"), value = NULL)

# Save data
fwrite(truth, here("data", "truth.csv"))
