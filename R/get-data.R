get_public_holidays <- function(today = Sys.Date(),
                                url = "https://raw.githubusercontent.com/KITmetricslab/hospitalization-nowcast-hub/main/other_data/public_holidays.csv") { # nolint
  message("Downloading public holiday data available on the: ", today)

  holidays <- data.table::fread(url)
  holidays <- data.table::melt(holidays, id.vars = "date")
  holidays <- holidays[value == TRUE]
  holidays <- holidays[
    ,
    .(report_date = date, location = variable, holiday = value)
  ]
  return(holidays[])
}

get_germany_hospitalisations <- function(today = Sys.Date(),
                                         url = "https://raw.githubusercontent.com/KITmetricslab/hospitalization-nowcast-hub/main/data-truth/COVID-19/COVID-19_hospitalizations_preprocessed.csv") { # nolint
  message("Downloading hospitalisation data available on the: ", today)

  germany_hosp <- data.table::fread(url)

  germany_hosp <- data.table::melt(
    germany_hosp,
    variable.name = "delay",
    value.name = "confirm",
    id.vars = c("date", "location", "age_group")
  )
  data.table::setnames(germany_hosp, "date", "reference_date")

  germany_hosp[, report_date := as.Date(reference_date) + 0:(.N - 1),
    by = c("reference_date", "location", "age_group")
  ]
  germany_hosp <- germany_hosp[report_date <= max(reference_date)]
  germany_hosp[, delay := NULL]
  germany_hosp[is.na(confirm), confirm := 0]
  germany_hosp[, confirm := cumsum(confirm),
    by = c("reference_date", "location", "age_group")
  ]
  germany_hosp[
    ,
    age_group := factor(
      age_group,
      levels = c("00+", "00-04", "05-14", "15-34", "35-59", "60-79", "80+")
    )
  ]
  holidays <- get_public_holidays(today)
  germany_hosp <- merge(
    germany_hosp, holidays,
    by = c("report_date", "location"), all.x = TRUE, all.y = FALSE
  )
  germany_hosp[is.na(holiday), holiday := FALSE]
  return(germany_hosp[])
}
