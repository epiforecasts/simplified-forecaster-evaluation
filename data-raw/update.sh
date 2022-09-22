
# Download metadata on forecasts  in the window of interest.

# Download hub forecasts of interest
Rscript data-raw/get-hub-forecasts.R

# Download truth data
Rscript data-raw/get-truth.R

# Get population data
Rscript data-raw/get-population.R

# Get anomalies data
Rscript data-raw/get-anomalies.R

# Make hub metadata for study period
Rscript data-raw/get-hub-metadata.R

# Calculate per forecast and quantile scores
Rscript data-raw/score-forecasts.R
