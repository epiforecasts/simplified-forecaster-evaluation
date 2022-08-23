# Data

File | Purpose
---|---
`get-hub-forecasts.R` | Download and process hub forecasts for the surrogate and ensemble model.
`get-hub-metadata.R` | Download and extract metadata about all forecasts submitted in the study period.
`get-population.R` | Download population data to be used to calculate incidence rates.
`get-truth.R` | Download JHU reported case data.
`score-forecasts.R` | Score all forecasts against truth data after normalising by population.
`update.sh` | Update all datasets and score forecasts.