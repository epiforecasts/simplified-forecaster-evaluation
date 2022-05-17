tar_target(latest_7day_hospitalisations, {
  copy(latest_hospitalisations)[,
    confirm := frollsum(confirm, n =  7), by = c("age_group", "location")
  ][!is.na(confirm)]
})
