#' Plot coverage at specified ranges
#'
#' @param coverage a  data.table of coverage
#'
#' @param ranges A numeric vector of credible interval ranges to plot.
#'
#' @return A ggplot2 object
#'
#' @import data.table
#' @import ggplot2
#' @import scales
#' @importFrom scoringutils theme_scoringtuils
plot_coverage_range <- function(coverage, ranges) {
  hlines <- data.table(
    range = paste0(ranges, "% interval"), nominal = ranges / 100
  )

  plot_cov_levels <- ggplot(coverage) +
    aes(
      x = horizon, y = coverage, colour = model,
      group = interaction(range, model)
    ) +
    geom_line() +
    geom_point() +
    geom_hline(
      data = hlines, aes(yintercept = nominal, x = NULL), linetype = "dashed"
    ) +
    scale_colour_brewer(palette = "Dark2") +
    scale_y_continuous(labels = percent) +
    facet_wrap(vars(range), ncol = 1, scales = "free_y") +
    theme_scoringutils() +
    labs(
      y = "Proportion of data within forecast interval",
      x = "Forecast horizon (weeks)",
      col = "Model"
    )
  return(plot_cov_levels)
}

#' Plot coverage at each quantile
#'
#' @param scores The output of [scoringutils::score()]
#'
#' @return A ggplot2 object
#'
#' @import scoringutils
#' @import ggplot2
#' @import scales
plot_coverage_quantiles <- function(scores) {
  plot_cov_quantile <- scores |>
    summarise_scores(by = c("model", "quantile", "horizon")) |>
    plot_quantile_coverage(scores) +
    aes(col = model) +
    scale_x_continuous(labels = percent) +
    scale_y_continuous(labels = percent) +
    scale_colour_brewer(palette = "Dark2") +
    guides(col = guide_none()) +
    facet_wrap(vars(horizon)) +
    labs(col = "Model", y = "Percent of observations below quantile")
  return(plot_cov_quantile)
}

#' Plot relative score by quantile
#'
#' @param relative_interval_score A data.table of relative scores
#'
#' @return A ggplot2 object
#'
#' @import data.table
#' @importFrom scoringutils theme_scoringutils
#' @import ggplot2
#' @import scales
plot_rel_score_by_quantile <- function(relative_interval_score) {
  plot_interval_score <- relative_interval_score |>
    copy() |>
    DT(,
      .(relative_interval_score = median(relative_interval_score)),
      by = c("horizon", "range")
    ) |>
    ggplot() +
    aes(
      x = range / 100, y = relative_interval_score, col = as.factor(horizon)
    ) +
    geom_hline(yintercept = 1, linetype = 2) +
    geom_point(size = 1.2) +
    geom_line(alpha = 0.8) +
    scale_x_continuous(labels = percent) +
    scale_y_continuous(
      trans = "log", breaks = c(seq(1, 2, by = 0.2), seq(2.4, 4, by = 0.4))
    ) +
    scale_colour_brewer(palette = "Accent") +
    theme_scoringutils() +
    labs(
      x = "Quantile", y = "Median relative interval score",
      col = "Forecast horizon (weeks)"
    )
  return(plot_interval_score)
}