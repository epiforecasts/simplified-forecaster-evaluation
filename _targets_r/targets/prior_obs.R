tar_target(
  prior_obs,
  enw_retrospective_data(
    hospitalisations[location == "DE"][age_group == "00+"],
    rep_date = as.Date("2021-07-01"), ref_days = max_report_delay
  ),
  cue = tar_cue(mode = "never")
)
