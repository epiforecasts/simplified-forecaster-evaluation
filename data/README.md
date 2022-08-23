# Data

File | Purpose
---|---
`forecast.csv` | hub forecasts for the surrogate and ensemble model as produced using `data/get-hub-forecasts.R`.
`metadata.csv` | Metadata about all forecasts submitted in the study period as produced using `data/get-hub-metadata.R`.
`truth.csv` | JHU reported case data as extracted from the ECDC hub and summarised into epidemiological weeks as produced using `data/get-truth.R`.
`population.csv` | Population data to be used to calculate incidence rates as produced using `data/get-population.R`.
`scores.csv` | Forecast scores as calculated using `scoringutils` on incidence rates using `data/get-forecasts.R`.