# Evaluating a simplified forecast model in comparison to the European forecasting hub ensemble

This repository contains the documentation, results, and code of a project evaluating a simplified forecasting model in comparison the European forecasting hub ensemble. See the documentation for further details. 

## Citation

*Not yet available.* 

## Project structure

Folder | Purpose
---|---
[`ecdc-weekly-growth-forecasts`](ecdc-weekly-growth-forecasts/) | The code for the simplified forecasting model evaluated in this work.
[`data-raw`](data-raw/) | Raw input data and scripts required to download and process it.
[`data`](data/) | Processed data from `data-raw` ready to be used in the paper analysis.
[`R`](R/) | R functions used in the analysis and for evaluation.
[`paper`](paper/) | Summary paper and additional supplementary information as `Rmarkdown` documents.
[`.github`](.github/) | GitHub actions used to build the docker image and render and publish the analysis paper.
[`.devcontainer`](.devcontainer/) | Resources for reproducibility using `vscode` and `docker`.

## Dependencies

Dependencies are managed using [`renv`](https://rstudio.github.io/renv/).

Alternatively a docker [container](https://github.com/epiforecasts/simplfied-forecaster-evaluation/blob/main/.devcontainer/Dockerfile) and [image](https://github.com/epiforecasts/simplfied-forecaster-evaluation/pkgs/container/simplfied-forecaster-evaluation) is provided. An easy way to make use of this is using the Remote development extension of `vscode`.

## Reproducibility

Once all dependencies are installed (see above) the paper analysis can be rerun using `paper/paper.Rmd` either interactively or rerendered as a document using `Rmarkdown`. To make this step easier we also provide a GitHub action to publish an updated version of the analysis to the `gh-pages` branch. 

See `data-raw` for the code to re-extract forecasts and truth data, create metadata, normalise by population, and score forecasts against truth data. All steps of this process can be done automatically using `data-raw/update.sh`. Results from these steps will be stored in `data` as `.csv` files.