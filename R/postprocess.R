adjust_quantile <- function(quantile, median, max_ratio = 0.5) {
  q_ratio <- quantile / median

  if (max(q_ratio, na.rm = TRUE) > 1) {
    quantile <- ifelse(
      q_ratio >= max_ratio + 1,
      (max_ratio + 1) * median,
      quantile
    )
  }else{
    quantile <- ifelse(
      q_ratio <= (1 - max_ratio),
      max_ratio * median,
      quantile
    )
  }
  return(quantile)
}

adjust_posteriors <- function(nowcasts, target, max_ratio = 0.25,
                              rhat_bound = 1.1, per_dt_bound = 0.2) {
  unadjusted_nowcasts <- nowcasts[
    !(max_rhat > rhat_bound | per_divergent_transitions > per_dt_bound)
  ]
  adjusted_nowcasts <- nowcasts[
    max_rhat > rhat_bound | per_divergent_transitions > per_dt_bound
  ]
  if (nrow(adjusted_nowcasts) > 0) {
    adjusted_nowcasts <- adjusted_nowcasts[,
      (target) := purrr::map(
        get(target),
        function(dt) {
          cols <- grep("^q[0-9]", colnames(dt), value = TRUE)
          dt[,
            (cols) := purrr::map(.SD, adjust_quantile, median = median,
                                  max_ratio = max_ratio),
            .SDcols = cols
          ]
        })
    ]
  nowcasts <- rbind(unadjusted_nowcasts, adjusted_nowcasts)
  }
  return(nowcasts)
}

unnest_nowcasts <- function(nowcasts, target) {

  nowcasts <- nowcasts[,
    (target) := pmap(
      list(get(target), model, nowcast_date),
        function(df, m, d) {
          df[, model := m][, nowcast_date := d]
        })][,
    rbindlist(get(target), use.names = TRUE, fill = TRUE)][
    order(location, age_group, nowcast_date, reference_date, model)
    ]

  data.table::setcolorder(nowcasts, neworder = c("model", "nowcast_date"))
  nowcasts[, nowcast_date := as.Date(nowcast_date)]
  nowcasts[, report_date := nowcast_date]
  return(nowcasts[])
}

format_for_submission <- function(nowcast, horizon = -28,
                                  pathogen = "COVID-19") {
  long <- epinowcast::enw_quantiles_to_long(nowcast)
  long <- long[
    as.character(quantile) %in% as.character(
      c(0.025, 0.1, 0.25, 0.5, 0.75, 0.9, 0.975)
    )
  ]
  long[quantile == "0.5", quantile := NA]
  long[, days_since_nowcast := as.numeric(
    as.Date(reference_date) - as.Date(nowcast_date)
  )]
  long <- long[days_since_nowcast >= horizon]
  long[, `:=`(
    target = paste0(
      days_since_nowcast, " day ahead inc hosp"
    ),
    type = "quantile"
  )]
  long[is.na(quantile), type := "median"]
  long <- long[, .(location, age_group,
    forecast_date = nowcast_date,
    target_end_date = reference_date, target, type, quantile,
    value = prediction, pathogen = pathogen, mean
  )]

  long <- rbind(
    data.table::copy(long)[, mean := NULL],
    unique(long[, value := NULL][,
                 `:=`(value = mean, type = "mean", quantile = NA)][,
                  mean := NULL]
    )
  )
  long[order(location, age_group, forecast_date, target_end_date)]
  return(long[])
}

summarise_runtimes <- function(nowcast) {
  run_time <- data.table::copy(nowcast)
  data.table::setcolorder(
    run_time, neworder = c("model", "nowcast_date", "run_time")
  )
  run_time_hier <- run_time[
    purrr::map_lgl(daily, ~ length(unique(.$age_group)) > 1)
  ][, .(model, nowcast_date, run_time)]

  run_time_ind <- run_time[
    purrr::map_lgl(
      daily, ~ length(unique(.$age_group)) == 1 & unique(.$location) == "DE"
    )
  ][,
    .(run_time = sum(run_time)), by = c("model", "nowcast_date")
  ]
  run_time_hier <- run_time_hier[, .(model, nowcast_date, run_time)]
  run_time <- rbind(run_time_hier, run_time_ind, use.names = TRUE, fill = TRUE)
  run_time <- run_time[,
    run_time_mins := run_time / 60][,
    run_time_hrs := run_time_mins / 60
  ]
  return(run_time[])
}