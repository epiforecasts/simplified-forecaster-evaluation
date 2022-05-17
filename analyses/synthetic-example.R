library(epinowcast)
library(covidregionaldata)
suppressMessages(library(data.table, quietly = TRUE))
suppressMessages(library(rstan, quietly = TRUE))
library(purrr)
library(here)

# load dev code
functions <- list.files(here("R"), full.names = TRUE)
walk(functions, source)

# set number of cores to use
options(mc.cores = 4)
# get example case counts
start_using_memoise()
latest_cases <- get_national_data("UK", verbose = FALSE)
latest_cases <- setDT(latest_cases)[date >= as.Date("2021-07-01")]
latest_cases <- latest_cases[, .(date, confirm = cases_new)]

# get a range of dates to generate synthetic data for
scenarios <- enw_random_intercept_scenario(
  obs = latest_cases,
  snapshots = seq(6 * 7, 0, by = -1),
  logmean = 1.9, logmean_sd = 0.1,
  logsd = 1, logsd_sd = 0.1
)

# simulate observations
scenarios <- enw_simulate_lnorm_trunc_obs(scenarios, latest_cases)
sim_reported_cases <- rbindlist(scenarios$reported_cases)
setnames(sim_reported_cases, "date", "reference_date")
sim_reported_cases <- rbind(
  copy(sim_reported_cases)[, age := 1],
  copy(sim_reported_cases)[, age := 2]
)

# Preprocess data
pobs <- enw_preprocess_data(sim_reported_cases, by = "age")

# Construct design matrices for the desired reference date effects
reference_effects <- enw_formula(pobs$metareference[[1]])

# Construct design matrices for the desired report day effects
report_effects <- enw_formula(pobs$metareport[[1]], random = "day_of_week")

# fit model to example data and produce nowcast
est <- epinowcast(pobs,
  report_effects = report_effects,
  reference_effects = reference_effects,
  debug = FALSE, pp = TRUE, save_warmup = FALSE
)

# summarise nowcast
summary(est)

# Plot nowcast vs latest observations
plot(est, latest_obs = copy(latest_cases)[, reference_date := date])

# Plot posterior prediction for observed cases at date of report
plot(est,
  latest_obs = copy(latest_cases)[, reference_date := date],
  type = "pos", log = TRUE
)
