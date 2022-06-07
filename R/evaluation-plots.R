#' Plot forecasts by forecast horizon
#'
#' @param forecasts A data.tabble of forecasts
#'
#' @param locs A character vector of locations to plot.
#'
#' @param ranges A numeric vector of credible interval ranges to plot.
#'
#' @return A ggplot2 object.
#' @importFrom scoringutils plot_predictions
#' @import ggplot2
#' @import data.table
plot_forecasts <- function(forecasts, locs, ranges) {
  forecasts[location_name %in% locs] |>
    DT(, date := target_end_date) |>
    plot_predictions(
      by = c("horizon", "location_name"), range = ranges
    ) +
    facet_grid(
      location_name ~ horizon, scales = "free_y"
    ) +
    aes(fill = model, col = model) +
    scale_y_log10(labels = comma, oob = squish, limits = c(NA, NA)) +
    scale_fill_brewer(palette = "Dark2") +
    scale_color_brewer(palette = "Dark2") +
    labs(x = "Date", fill = "Model", col = "Model", ramp = "Range",
          y = "Notified test positive cases per 10,000 population")
}

plot_wis <- function(wis, locs) {
  wis |>
    DT(location_name %in% locs) |>
    DT(horizon == 1 | horizon == 4) |>
    ggplot() +
    aes(
      x = target_end_date, y = interval_score, col = model,
      shape = as.factor(horizon)
    ) +
    geom_point(size = 1.2) +
    geom_line(alpha = 0.8) +
    scale_color_brewer(palette = "Dark2") +
    theme_scoringutils() +
    theme(legend.position = "bottom") +
    scale_y_log10() +
    facet_wrap(vars(location_name), scales = "free_y", ncol = 1) +
    labs(
      x = "Date", y = "Weighted interval score",
      col = "Model", shape =  "Forecast horizon (weeks)"
    )
}

plot_relative_wis <- function(relative_wis, alpha = 0.8,
                              jittered_points = TRUE,
                              quantiles = c(0.05, 0.35, 0.65, 0.95), ...) {
  relative_wis |>
    copy() |>
    ggplot() +
    aes(x = relative_interval_score, ...) +
    geom_density_ridges(
      scale = 1.5, alpha = alpha, quantile_lines = TRUE,
      quantiles = quantiles,
      jittered_points = jittered_points,
      position = position_points_jitter(width = 0.05, height = 0),
      point_shape = "|", point_size = 3, point_alpha = 0.3
    ) +
    scale_x_continuous(
      trans = "log", limits = c(NA, 5),
      breaks = c(seq(0, 2, by = 0.2), seq(2.5, 5, by = 0.5))
    ) +
    geom_vline(xintercept = 1, linetype = 2, size = 1.05, alpha = 0.8) +
    theme_scoringutils() +
    labs(x = "Relative weighted interval score")
}
