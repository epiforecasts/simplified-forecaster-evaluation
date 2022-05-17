tar_file(
  save_latest_7day_hospitalisations,
  save_csv(
    latest_7day_hospitalisations,
    filename = paste0("seven_day.csv"),
    path = here("data/observations")
  )
)
