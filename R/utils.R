#' Save a plot and return the path for targets
#' @importFrom ggplot2 ggsave
save_plot <- function(plot, filename, path, ...) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  path <- file.path(path, file)
  ggplot2::ggsave(path, plot, ...)
  return(filename)
}

#' Save a dataframe to a csv and return the path for targets
save_csv <- function(dt, filename, path, allow_empty = TRUE) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  path <- file.path(path, filename)

  if (allow_empty | nrow(dt) > 0) {
    data.table::fwrite(dt, path)
  }
  return(path)
}

drop_string <- function(var, string) {
  var[!grepl(string, var)]
}

select_var <- function(dt, var) {
  dt[[var]]
}

format_from_csv <- function(dt) {
  if (!is.null(dt$age_group)) {
      dt[
      ,
        age_group := factor(
          age_group,
          levels = c("00+", "00-04", "05-14", "15-34", "35-59", "60-79", "80+")
        )
    ]
    }
    dt[,
    model := factor(
      model,
      levels = c("Reference: Fixed, Report: Fixed",
                "Reference: Fixed, Report: Day of week",
                "Reference: Age, Report: Day of week",
                "Reference: Age and week, Report: Day of week",
                "Reference: Age and week by age, Report: Day of week",
                "Independent by age, Reference: Week, Report: Day of week",
                "Independent by age, Reference: Week and day of week, Report: Day of week" # nolint
                )
    )
    ]
  return(dt[])
}

load_nowcasts <- function(path) {
  nowcasts <- fs::dir_ls(
    path,
    glob = "*.csv"
  ) |>
    purrr::map(data.table::fread) |>
    data.table::rbindlist(use.names = TRUE, fill = TRUE)
  nowcasts[, horizon := as.numeric(
    as.Date(reference_date) - as.Date(nowcast_date)
  )]
  nowcasts <- format_from_csv(nowcasts)
  return(nowcasts[])
}

load_obs <- function(path) {
  obs <- fread(path)
  obs[
    ,
    age_group := factor(
      age_group,
      levels = c("00+", "00-04", "05-14", "15-34", "35-59", "60-79", "80+")
    )
  ]
  return(obs[])
}

load_diagnostics <- function(path) {
  diagnostics <- fread(path)
  diagnostics <- format_from_csv(diagnostics)
  return(diagnostics[])
}

fancy_datatable <- function(dt) {
  dt <- janitor::clean_names(dt, case = "sentence")
  DT::datatable(
    dt,
    extensions = c("Buttons", "Responsive", "Scroller"),
    options = list(
      dom = "Bfrtip", buttons = c("csv"),
      pageLength = 7, deferRender = TRUE,
      scrollY = 200, scroller = TRUE
    )
  )
}
