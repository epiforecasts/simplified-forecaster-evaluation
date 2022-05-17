tar_map(
  list(score_by = list(
    "overall", "age_group", "horizon", "reference_date", "nowcast_date"
  )),
  tar_target(
    scores,
    enw_score_nowcast(
      scored_nowcasts, complete_hospitalisations, 
      summarise_by = drop_string(c(score_by, "model"), "overall"),
      log = FALSE
    )
  ),
  tar_target(
    log_scores,
    enw_score_nowcast(
      scored_nowcasts, complete_hospitalisations, 
      summarise_by = drop_string(c(score_by, "model"), "overall"),
      log = TRUE
    )
  ),
  tar_file(
    save_scores,
    save_csv(
      rbind(scores[, scale := "natural"], log_scores[, scale := "log"]),
      filename = paste0(paste(score_by, sep = "-"), ".csv"),
      path = here("data/scores")
    )
  )
)
