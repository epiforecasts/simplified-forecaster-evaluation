tar_target(combined_nowcasts, {
  rbindlist(list(
    fixed_nowcast,
    dow_nowcast,
    age_nowcast,
    week_nowcast,
    age_week_nowcast,
    independent_nowcast,
    overall_only_nowcast,
    independent_ref_dow_nowcast
  ), use.names = TRUE, fill = TRUE)[,
     model := factor(
      model,
      levels = c("Reference: Fixed, Report: Fixed",
                 "Reference: Fixed, Report: Day of week",
                 "Reference: Age, Report: Day of week",
                 "Reference: Age and week, Report: Day of week",
                 "Reference: Age and week by age, Report: Day of week",
                 "Independent by age, Reference: Week, Report: Day of week",
                 "Independent by age, Reference: Week and day of week, Report: Day of week")
     )
    ][, id := 1:.N]
})
