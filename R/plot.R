plot_nowcast <- function(summarised_nowcast, latest_obs,
                                     max_delay = Inf, ...) {
   summarised_nowcast <- summarised_nowcast[
        reference_date >= (max(as.Date(nowcast_date)) - max_delay)
   ]

   suppressWarnings(summarised_nowcast[, holiday := NULL])

   plot <- epinowcast::enw_plot_nowcast_quantiles(
      summarised_nowcast,
      latest_obs = latest_obs[
        reference_date >= min(summarised_nowcast$reference_date)][
        reference_date <= max(summarised_nowcast$reference_date)
      ], ...
  )
  return(plot)
}

plot_scores <- function(scores, ...) {
  ggplot2::ggplot(scores) +
    ggplot2::aes(...) +
    ggplot2::geom_point(size = 1.2) +
    ggplot2::geom_line(size = 1.1, alpha = 0.4) +
    ggplot2::scale_fill_brewer(palette = "Paired") +
    ggplot2::scale_color_brewer(palette = "Paired") +
    labs(y = "Weighted interval score") +
    theme_bw() +
    theme(legend.position = "bottom") +
    guides(fill = guide_legend(title = "Model", nrow = 4),
           col = guide_legend(title = "Model", nrow = 4))
}

plot_relative_scores <- function(score, baseline) {
  score <- data.table::as.data.table(score)
  fixed_score <- score[
    model %in% baseline,
    .(reference_date, age_group, fixed_is = interval_score)
  ]
  score <- merge(score, fixed_score, by = c("reference_date", "age_group"))

  score <- score[, interval_score := interval_score / fixed_is]
  score <- score[!model %in% baseline]
  plot <- ggplot(score) +
    aes(x = reference_date, y = interval_score, col = model) +
    geom_hline(yintercept = 1, linetype = 2, size = 1.2, alpha = 0.5) +
    geom_line(size = 1.1, alpha = 0.6) +
    geom_point(size = 1.2) +
    facet_wrap(vars(age_group)) +
    scale_color_brewer(palette = "Paired") +
    scale_y_log10(labels = scales::percent)

  plot <- enw_plot_theme(plot) +
    labs(
      x = "Reference date",
      y = paste0("Weighted interval score (", baseline, ")")
    ) + # nolint
    guides(col = guide_legend(title = "Model", ncol = 2))
  return(plot[])
}
