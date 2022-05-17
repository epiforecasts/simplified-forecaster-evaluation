tar_target(
  independent_submission_nowcast,
  rbind(
    independent_ref_dow_nowcast[nowcast_date == nowcast_dates],
    overall_only_nowcast[nowcast_date == nowcast_dates]
  ) |> 
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
