tar_target(nowcast_dates, {
  unique(
    hospitalisations[reference_date >= start_date]$reference_date
  )
})
