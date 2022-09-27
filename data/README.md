# Data

File | Purpose
---|---
`forecast.csv` | Hub forecasts for the surrogate and ensemble model as produced using `data/get-hub-forecasts.R`.
`metadata.csv` | Metadata about all forecasts submitted in the study period as produced using `data/get-hub-metadata.R`.
`truth.csv` | JHU reported case data as extracted from the European hub and summarised into epidemiological weeks as produced using `data/get-truth.R`.
`population.csv` | Population data to be used to calculate incidence rates as produced using `data/get-population.R`.
`forecasts_ready_for_scoring.csv` | Hub forecasts for the surrogate and ensemble model as produced using `data/get-hub-forecasts.R` but processed ready for scoring, including the removal of anomalies using `data/score-forecasts.R`.
`scores.csv` | Forecast scores as calculated using `scoringutils` on incidence rates using `data/score-forecasts.R`.