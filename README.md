
# Evaluating a simplified forecast model in comparison to the ECDC forecasting hub ensemble

This repository contains the documentation, results, and code of a
project evaluating a simplified forecasting model in comparison the ECDC
forecasting hub ensemble. See the documentation for further details.

## Citation

## Project structure

| Folder | Purpose |
| ------ | ------- |

[`ecdc-weekly-growth-forecasts`](ecdc-weekly-growth-forecasts/) | The
code for the simplified forecasting model evaluated in this work.
[`data-raw`](data-raw/) | Raw input data and scripts required to
download and process it. [`data`](data/) | Processed data from
`data-raw` ready to be used in the paper analysis. [`R`](R/) | R
functions used in the analysis and for evaluation. [`paper`](paper/) |
Summary paper and additional supplementary information as `Rmarkdown`
documents. [`.devcontainer`](.devcontainer/) | Resources for
reproducibility using `vscode` and `docker`.

## Dependencies

Dependencies are managed using \[`renv`\].

Alternatively a docker
[container](https://github.com/epiforecasts/simplfied-forecaster-evaluation/blob/main/.devcontainer/Dockerfile)
and
[image](https://github.com/epiforecasts/simplfied-forecaster-evaluation/pkgs/container/simplfied-forecaster-evaluation)
is provided. An easy way to make use of this is using the Remote
development extension of `vscode`.
