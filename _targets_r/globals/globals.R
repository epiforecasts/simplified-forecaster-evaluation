library(targets)
library(tarchetypes)
library(cmdstanr)
library(data.table)
library(epinowcast)
library(ggplot2)
library(purrr, quietly = TRUE)
library(here)
library(future)
library(future.callr)
plan(callr)
functions <- list.files(here("R"), full.names = TRUE)
walk(functions, source)
rm("functions")
set_cmdstan_path()  
tar_option_set(
  packages = c("data.table", "epinowcast", "scoringutils", "ggplot2", "purrr",
               "cmdstanr", "here"),
  deployment = "worker",
  memory = "transient",
  workspace_on_error = TRUE,
  error = "continue",
  garbage_collection = TRUE
)
