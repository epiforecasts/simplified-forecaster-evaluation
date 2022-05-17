tar_target(
  dow_nowcast,
  nowcast(
    obs = hospitalisations_by_date_report,
    tar_loc = locations,
    model = dow_epinowcast,
    priors = priors,
    max_delay = max_report_delay,
    settings = epinowcast_settings
  ),
  cross(hospitalisations_by_date_report, locations),
  cue = tar_cue(mode = "never")
)
