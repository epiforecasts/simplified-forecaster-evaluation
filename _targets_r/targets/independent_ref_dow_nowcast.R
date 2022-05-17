tar_target(
  independent_ref_dow_nowcast,
  nowcast(
    obs = hospitalisations_by_date_report[age_group == age_groups],
    tar_loc = locations,
    model = independent_ref_dow_epinowcast,
    priors = priors,
    max_delay = max_report_delay,
    settings = epinowcast_settings
  ),
  cross(hospitalisations_by_date_report, locations, age_groups),
  cue = tar_cue(mode = "never")
)
