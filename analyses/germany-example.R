library(epinowcast)
suppressMessages(library(data.table, quietly = TRUE))
library(purrr)
library(here)

# load dev code
functions <- list.files(here("R"), full.names = TRUE)
walk(functions, source)

# set number of cores to use
options(mc.cores = 4)

# get processed germany data and reprocess
germany_hosp <- get_germany_hospitalisations()

# national only and only for the last 28 days of data
germany_nat_hosp <- germany_hosp[location == "DE"]
germany_nat_hosp <-
  germany_nat_hosp[reference_date >= (max(reference_date) - 27)]

# Preprocess data
pobs <- enw_preprocess_data(germany_nat_hosp, by = "age_group", max_delay = 30)

# Construct design matrices for the desired reference date effects
reference_effects <- enw_formula(pobs$metareference[[1]])

# Construct design matrices for the desired report day effects
report_effects <- enw_formula(pobs$metareport[[1]], random = "day_of_week")

# fit model to example data and produce a nowcast
est <- epinowcast(pobs,
  report_effects = report_effects,
  reference_effects = reference_effects,
  debug = FALSE, pp = TRUE, save_warmup = FALSE,
)

# observations linked to truncation adjusted estimates
summary(nowcast)

# Plot nowcast vs latest observations
plot(est, obs = latest_cases)

# Plot posterior prediction for observed cases at date of report
plot(est, obs = latest_cases, type = "pos", log = TRUE)
