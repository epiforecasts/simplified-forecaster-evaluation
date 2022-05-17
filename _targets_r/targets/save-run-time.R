tar_file(
  save_run_time,
  combined_nowcasts |>
    summarise_runtimes() |>
    save_csv(
      filename = "run-times.csv",
      path = here("data/diagnostics")
    )
)
