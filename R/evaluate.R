calc_coverage <- function(scores) {
  scores |>
    copy() |>
    DT(, horizon := as.character(horizon)) |>
    DT(, coverage_deviation := NULL) |>
    add_coverage(ranges = ranges, by = c("model", "horizon")) |>
    summarise_scores(fun = signif, digits = 2, by = c("model", "horizon")) |>
    melt(
      measure.vars = patterns("coverage_"), variable.name = "range",
      value.name = "coverage"
    )|>
    DT(, range := gsub("coverage_", "", range)) |>
    DT(, range := paste0(range, "% interval"))
}

calc_relative_score <- function(scores, cols) {
  scores |>
    copy() |>
    setorderv(cols) |>
    DT(, c(..cols, "model", "interval_score")) |>
    unique() |>
    DT(,
      relative_interval_score := interval_score / shift(interval_score),
      by = cols
    ) |>
    DT(model %in% "Surrogate")
}
