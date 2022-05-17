tar_target(priors, {
  do.call(prior_epinowcast, c(
    list(
      prior_obs, max_delay = max_report_delay, scale = 10,
      priors = uninformed_priors
    ),
    epinowcast_settings
  ))
})
