tar_file(
  save_daily_nowcasts,
  summarised_nowcast[nowcast_date == nowcast_dates] |>
    save_csv(
      filename = paste0(nowcast_dates, ".csv"),
      path = here("data/nowcasts/daily"),
      allow_empty = FALSE
    ),
  map(nowcast_dates),
  cue = tar_cue(mode = "never")
)
