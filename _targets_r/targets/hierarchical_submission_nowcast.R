tar_target(
  hierarchical_submission_nowcast,
  age_week_nowcast[nowcast_date == nowcast_dates] |>
    adjust_posteriors(
      target = "seven_day", 
      max_ratio = 0.25, 
      rhat_bound = 1.1,
      per_dt_bound = 0.2
    ) |>
    select_var("seven_day") |>
    rbindlist() |>
    format_for_submission(),
  map(nowcast_dates),
  iteration = "list",
  cue = tar_cue(mode = "never")
)
