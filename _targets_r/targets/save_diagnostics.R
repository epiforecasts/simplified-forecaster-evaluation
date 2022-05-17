list(
  tar_file(
    save_all_diagnostics,
      save_csv(
        diagnostics,
        filename = "all.csv",
        path = here("data/diagnostics")
      )
  ),
  tar_file(
    save_high_rhat_diagnostics,
      save_csv(
        diagnostics[max_rhat > 1.05],
        filename = "high-rhat.csv",
        path = here("data/diagnostics")
      )
  ),
  tar_file(
    save_high_divergent_transitions,
      save_csv(
        diagnostics[per_divergent_transitions > 0.1],
        filename = "high-divergent-transitions.csv",
        path = here("data/diagnostics")
      )
  ),
  tar_file(
    save_failures,
      save_csv(
        diagnostics[failure == TRUE],
        filename = "fitting-failed.csv",
        path = here("data/diagnostics")
      )
  )
)
