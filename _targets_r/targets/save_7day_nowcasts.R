tar_file(
  save_7day_nowcasts,
  summarised_7day_nowcast[nowcast_date == nowcast_dates] |>
    save_csv(
      filename = paste0(nowcast_dates, ".csv"),
      path = here("data/nowcasts/seven_day"),
      allow_empty = FALSE
    ),
  map(nowcast_dates),
  cue = tar_cue(mode = "never")
)
