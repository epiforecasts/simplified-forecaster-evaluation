tar_target(summarised_nowcast, {
  combined_nowcasts |> 
    adjust_posteriors(
      target = "daily", 
      max_ratio = 0.25, 
      rhat_bound = 1.1,
      per_dt_bound = 0.2
  ) |> 
    unnest_nowcasts(target = "daily") 
})
