tar_target(scored_nowcasts, {
  summarised_nowcast[location == locations][
    reference_date < (max(nowcast_date) - 28)][,
    holiday := NULL][,
    horizon := as.numeric(as.Date(reference_date) - nowcast_date)][
    horizon >= -7
  ]
})
