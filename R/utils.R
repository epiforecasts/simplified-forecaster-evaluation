merge_forecasts_with_truth <- function(forecasts, truth) {
  forecasts <- data.table::copy(forecasts)
  truth <- data.table::copy(truth)

  data.table::setnames(truth, "date", "target_end_date")

  forecasts_with_truth <- truth[
    forecasts, on = c("location", "target_end_date")
  ]

  # Remove point forecasts
  forecasts_with_truth <- forecasts_with_truth[!is.na(quantile)]

  # Remove forecasts with no truth data
  forecasts_with_truth <- forecasts_with_truth[!is.na(true_value)]

  return(forecasts_with_truth)
}

rescale_to_incidence_rate <- function(forecasts, population, scale = 1e5) {
  forecasts <- data.table::copy(forecasts)
  population <- data.table::copy(population)

  forecasts_with_population <- forecasts[population, on = c("location")] |>
    data.table::DT(, true_value := true_value / population * scale) |>
    data.table::DT(, prediction := prediction / population * scale)

  return(forecasts_with_population)
}