tar_file(
  save_independent_submission,
  save_csv(
    independent_submission_nowcast,
    filename = paste0(nowcast_dates, ".csv"),
    path = here("data/nowcasts/submission/independent")
  ),
  map(independent_submission_nowcast, nowcast_dates)
)
