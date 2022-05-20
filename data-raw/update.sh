
# Download metadata on forecasts  in the window of interest.

# Download hub forecasts of interest
Rscript data-raw/get-hub-forecasts.R

# Download truth data
Rscript data-raw/get-truth.R

# Calculate per forecast and quantile scores
Rscript data-raw/score-forecasts.R
