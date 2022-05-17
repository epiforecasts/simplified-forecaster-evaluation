tar_target(
  hospitalisations_by_date_report,
  enw_retrospective_data(
    hospitalisations,
    rep_date = nowcast_dates,
    ref_days = max_report_delay
  )[, nowcast_date := nowcast_dates],
  map(nowcast_dates),
  iteration = "list",
  cue = tar_cue(mode = "never")
)
