score_nowcast <- function(nowcast, obs, by = "model") {
  scores <- epinowcast::enw_score_nowcast(
      nowcast, obs, log = FALSE,
      summarise_by = by
  )
  log_scores <- epinowcast::enw_score_nowcast(
      nowcast, obs, log = TRUE,
      summarise_by = by
  )
  scores <- rbind(scores[, scale := "natural"], log_scores[, scale := "log"])
  return(scores[])
}
