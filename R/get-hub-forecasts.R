start_using_memoise <- function(path = tempdir()) {
  message("Using a cache at: ", path)
  options("useMemoise" = TRUE, cache_path = path)
}

stop_using_memoise <- function() {
  if (!is.null(options("useMemoise"))) {
    options("useMemoise" = NULL)
  }
}

reset_cache <- function() {
  unlink(getOption("cache_path"), recursive = TRUE)
  memoise::cache_filesystem(getOption("cache_path"))
  return(invisible(NULL))
}

# Get all the paths for the repository
get_github_paths <- function(repo, branch = "main", depth = 0) {
  return <- gh::gh(
    "/repos/{repo}/git/trees/{branch}?recursive={depth}",
    method = "GET",
    repo = repo,
    branch = branch,
    depth = depth
  )

  dt <- purrr::map(
    return$tree,
    ~ data.table::data.table(
      path = .$path
    )
  )
  dt <- data.table::rbindlist(dt)
  return(dt[])
}

# Filter paths for targets of interest
filter_paths <- function(paths, string) {
  paths <- paths[grepl(string, path)]
  return(paths)
}

# Filter paths for models and dates we want from a target folder
get_hub_forecast_paths <- function(repo, branch = "main",
                                   folder = "data-processed", models, dates) {

  paths <- get_github_paths(repo = repo, branch = branch, depth = 15)

  paths <- paths |>
    filter_paths(paste0(folder, "/")) |>
    filter_paths(".csv")

  if (!missing(models)) {
    paths <- purrr::map(models, ~ filter_paths(paths, .))
    paths <- data.table::rbindlist(paths)
  }

  if (!missing(dates)) {
    paths <- purrr::map(dates, ~ filter_paths(paths, .))
    paths <- data.table::rbindlist(paths)
  }
  return(paths[])
}

# Download a forecast with error protection
# use of fread means that data can be filtered prior to loading into R
download_forecast <- function(repo, path, branch, ...) {
  sfread <- data.table::fread
  if (!is.null(getOption("useMemoise"))) {
    if (getOption("useMemoise")) {
      ch <- memoise::cache_filesystem(getOption("cache_path"))
      sfread <- memoise::memoise(sfread, cache = ch)
    }
  }
  sfread <- purrr::safely(sfread)
  url <- glue::glue("https://raw.githubusercontent.com/{repo}/{branch}/{path}")
  forecast <- suppressMessages(sfread(url, ...))
  if (!is.null(forecast$error)) {
    warning("Forecast with the following path could not be downloaded: ", path)
    print(forecast$error)
  }
  return(forecast$result[])
}

# Extract forecast model names from queried path
# This function relies on forecasts being at 1 folder
# deep in a hub repository and so is not fully robust to
# organisational changes
extract_forecast_models <- function(paths) {
  paths <- paths[,
      path := purrr::map_chr(
          path, ~ strsplit(gsub(".csv", "", .), "/")[[1]][2]
        )
    ]
  data.table::setnames(paths, "path", "model")
  return(paths[])
}

# Get a vector of available models based on currently queried paths
available_forecast_models <- function(paths) {
  paths <- extract_forecast_models(paths)
  models <- unique(paths$model)
  return(models)
}

# Get hub forecasts for a set of models and dates
get_hub_forecasts <- function(repo, branch = "main", folder = "data-processed",
                              models, dates, path_to_model = TRUE, ...) {
  paths <- get_hub_forecast_paths(
    repo, branch = branch, folder = folder, models, dates
  )

  forecasts <- purrr::map(
    paths$path, ~ download_forecast(repo = repo, branch = branch, .), ...
  )
  names(forecasts) <- paths$path
  forecasts <- data.table::rbindlist(
    forecasts, use.names = TRUE, fill = TRUE, idcol = "path"
  )

  if (path_to_model) {
    forecasts <- extract_forecast_models(forecasts)
  }
  return(forecasts[])
}
