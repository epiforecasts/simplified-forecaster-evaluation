# Bash scripts

This folder contains `bash` scripts used to orchestrate project tasks such as running nowcasts on new data, publishing nowcasts, and updating remote repositories. The table below summarises key files.



Folder | Purpose
---|---
`render-targets.sh` | Updates the targets workflow by rendering the `_targets.Rmd` file.
`make-targets.sh` | Runs `targets::tar_make()`. Sequentially updates targets. This is not recommended if actually updating the workflow as the compute requirements of the nowcast models means this could take a very long time.
`make-parallel-targets.sh` | Uses `targets::tar_make_future()` to update targets in parallel. By default in the code this uses a `future.callr` backend and allocates half the number of available cores (with 2 cores used per model fit). If running the pipeline yourself this likely needs configuration.
`update-targets.sh` | Updates the workflow and then runs it in parallel using `render-targets.sh` and `make-parallel-targets.sh`. Updating the pipeline is run using `nohup` as a background process. Output is sent to `render.log` and `targets.log` respectively.
`update-git-remote.sh` | Pushes updated results to the git remote origin using a dated commit. Upstream changes are first merged.
`update-targets-remote.sh` | Takes a snapshot of the `_targets` directory using `gittargets::tar_git_snapshot()` and then pushes this to the remote archive using functionality in `R/targets-archive.R`.
`update-targets-and-publish.sh` | Updates the workflow in the same way as `update-targets.sh` but runs the workflow twice to guard against transient workflow errors. Results are the publish using the update remote tasks. This is the script used in a CRON job to update nowcasts each day.
`update-if-new-data.sh` | The pipeline itself will only start running if new data has been downloaded compared to the last full run of the pipeline. This script wraps `update-targets-and-publish.sh` but adds a safety check for use in production that first makes a cache of the target data and clears it once the pipeline is complete. The cache is checked every time this script is run and action only taken if missing. This means that `update-targets-and-publish.sh` can be run safely in a cron job with no overlap issues.