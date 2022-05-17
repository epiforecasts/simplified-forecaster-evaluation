tar_target(
  overall_only_nowcast,
  nowcast(
    obs = hospitalisations_by_date_report[age_group == "00+"],
    tar_loc = other_locations,
    model = independent_ref_dow_epinowcast,
    priors = priors,
    max_delay = max_report_delay,
    settings = epinowcast_settings
  ),
  cross(hospitalisations_by_date_report, other_locations),
  cue = tar_cue(mode = "never")
)
