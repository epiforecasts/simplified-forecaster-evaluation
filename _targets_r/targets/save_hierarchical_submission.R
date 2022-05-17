tar_file(
  save_hierarchical_submission,
  save_csv(
    hierarchical_submission_nowcast,
      filename = paste0(nowcast_dates, ".csv"),
      path = here("data/nowcasts/submission/hierarchical")
  ),
  map(hierarchical_submission_nowcast, nowcast_dates)
)
