fixed_epinowcast <- function(obs, max_delay = 40, ...) {
  pobs <- enw_preprocess_data(
    obs,
    rep_holidays = "holiday",
    max_delay = max_delay, by = "age_group"
  )

  reference_effects <- enw_formula(pobs$metareference)
  report_effects <- enw_formula(pobs$metareport)

  model <- load_model()

  nowcast <- epinowcast(
    pobs,
    model = model,
    reference_effects = reference_effects,
    report_effects = report_effects,
    ...
  )

  nowcast <- default_nowcast_on_error(nowcast, pobs, model, ...)

  out <- summarise_nowcast(nowcast, model = "Reference: Fixed, Report: Fixed")
  return(out[])
}

dow_epinowcast <- function(obs, max_delay = 40, ...) {
  pobs <- enw_preprocess_data(
    obs,
    rep_holidays = "holiday",
    max_delay = max_delay, by = "age_group"
  )

  reference_effects <- enw_formula(pobs$metareference)
  report_effects <- enw_formula(pobs$metareport, random = "day_of_week")

  model <- load_model()

  nowcast <- epinowcast(
    pobs,
    model = model,
    reference_effects = reference_effects,
    report_effects = report_effects,
    ...
  )

  nowcast <- default_nowcast_on_error(nowcast, pobs, model, ...)

  out <- summarise_nowcast(
    nowcast,
    model = "Reference: Fixed, Report: Day of week"
  )
  return(out[])
}

age_epinowcast <- function(obs, max_delay = 40, ...) {
  pobs <- enw_preprocess_data(
    obs,
    rep_holidays = "holiday",
    max_delay = max_delay, by = "age_group"
  )

  reference_effects <- enw_formula(pobs$metareference, random = "age_group")
  report_effects <- enw_formula(pobs$metareport, random = "day_of_week")

  model <- load_model()

  nowcast <- epinowcast(
    pobs,
    model = model,
    reference_effects = reference_effects,
    report_effects = report_effects,
    ...
  )

  nowcast <- default_nowcast_on_error(nowcast, pobs, model, ...)

  out <- summarise_nowcast(
    nowcast,
    model = "Reference: Age, Report: Day of week"
  )
  return(out[])
}

week_epinowcast <- function(obs, max_delay = 40, ...) {
  pobs <- enw_preprocess_data(
    obs,
    rep_holidays = "holiday",
    max_delay = max_delay, by = "age_group"
  )

  metareference <- enw_add_cumulative_membership(
    pobs$metareference[[1]],
    feature = "week"
  )
  reference_effects <- enw_formula(
    metareference,
    random = "age_group", custom_random = "cweek"
  )
  report_effects <- enw_formula(pobs$metareport, random = "day_of_week")

  model <- load_model()

  nowcast <- epinowcast(
    pobs,
    model = model,
    reference_effects = reference_effects,
    report_effects = report_effects,
    ...
  )

  nowcast <- default_nowcast_on_error(nowcast, pobs, model, ...)

  out <- summarise_nowcast(
    nowcast,
    model = "Reference: Age and week, Report: Day of week"
  )
  return(out[])
}

age_week_epinowcast <- function(obs, max_delay = 40, ...) {
  pobs <- enw_preprocess_data(
    obs,
    rep_holidays = "holiday",
    max_delay = max_delay, by = "age_group"
  )

  metareference <- pobs$metareference[[1]]

  metareference <- enw_add_cumulative_membership(
    pobs$metareference[[1]],
    feature = "week"
  )

  fixed_form <- as.formula(paste0(
    "~ 1 + age_group + ",
    paste(paste0(
      "age_group:",
      grep("cweek", colnames(metareference), value = TRUE),
      collapse = " + "
    ))
  ))
  fixed <- enw_design(fixed_form, metareference,
    no_contrasts = TRUE,
    sparse = TRUE
  )

  effects <- enw_effects_metadata(fixed$design)

  effects <- enw_add_pooling_effect(effects, "age_group", "age_group")
  for (i in unique(metareference$age_group)) {
    effects <- enw_add_pooling_effect(
      effects, c("cweek", paste0("age_group", i)), paste0(i, "_walk"),
      finder_fn = function(effect, pattern) {
        grepl(pattern[1], effect) & startsWith(effect, pattern[2])
      }
    )
  }
  effects[grepl(":", effects), age_group := 0]

  form <- as.formula(
    paste0(
      "~ 0 + fixed + age_group + ",
      paste(paste0("`", unique(metareference$age_group), "_walk`"),
        collapse = " + "
      )
    )
  )
  random <- enw_design(form, effects, sparse = FALSE)
  reference_effects <- list(fixed = fixed, random = random)

  report_effects <- enw_formula(pobs$metareport, random = "day_of_week")

  model <- load_model()

  nowcast <- epinowcast(
    pobs,
    model = model,
    reference_effects = reference_effects,
    report_effects = report_effects,
    ...
  )

  nowcast <- default_nowcast_on_error(nowcast, pobs, model, ...)

  out <- summarise_nowcast(
    nowcast,
    model = "Reference: Age and week by age, Report: Day of week"
  )
  return(out[])
}

independent_epinowcast <- function(obs, max_delay = 40, ...) {
  pobs <- enw_preprocess_data(obs,
    max_delay = max_delay,
    rep_holidays = "holiday"
  )

  metareference <- enw_add_cumulative_membership(
    pobs$metareference[[1]],
    feature = "week"
  )

  reference_effects <- enw_formula(metareference, custom_random = "cweek")
  report_effects <- enw_formula(pobs$metareport, random = "day_of_week")

  model <- load_model()

  nowcast <- epinowcast(
    pobs,
    model = model,
    reference_effects = reference_effects,
    report_effects = report_effects,
    ...
  )

  nowcast <- default_nowcast_on_error(nowcast, pobs, model, ...)

  out <- summarise_nowcast(
    nowcast,
    model = "Independent by age, Reference: Week, Report: Day of week"
  )
  return(out[])
}

independent_ref_dow_epinowcast <- function(obs, max_delay = 40, ...) {
  pobs <- enw_preprocess_data(obs,
    max_delay = max_delay,
    rep_holidays = "holiday"
  )

  metareference <- enw_add_cumulative_membership(
    pobs$metareference[[1]],
    feature = "week"
  )

  reference_effects <- enw_formula(
    metareference, random = "day_of_week", custom_random = "cweek"
  )
  report_effects <- enw_formula(pobs$metareport, random = "day_of_week")

  model <- load_model()

  nowcast <- epinowcast(
    pobs,
    model = model,
    reference_effects = reference_effects,
    report_effects = report_effects,
    ...
  )

  nowcast <- default_nowcast_on_error(nowcast, pobs, model, ...)

  out <- summarise_nowcast(
    nowcast,
    model = "Independent by age, Reference: Week and day of week, Report: Day of week" # nolint
  )
  return(out[])
}
