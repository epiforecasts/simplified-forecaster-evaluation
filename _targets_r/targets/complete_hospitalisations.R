tar_target(complete_hospitalisations, {
  latest_hospitalisations[reference_date < (max(reference_date) - 28)]
})
