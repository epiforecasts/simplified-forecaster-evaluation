
# Evaluating a simplified forecast model in comparison to the ECDC forecasting hub ensemble

This repository contains the documentation, results, and code of a
project evaluating … See the documentation for further details.

## Citation

## Documentation

| Document                                                                                                       | Purpose                                                                                                                                                                                                                                            |
|----------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Summary](https://epiforecasts.io/eval-germany-sp-nowcasting/)                                                 | A summary of this work.                                                                                                                                                                                                                            |
| [Paper](https://epiforecasts.io/eval-germany-sp-nowcasting/paper.pdf)                                          | The academic paper write up of this work.                                                                                                                                                                                                          |
| [Supplementary information](https://epiforecasts.io/eval-germany-sp-nowcasting/si.html)                        | The supplementary information for the write up of this work.                                                                                                                                                                                       |
| [Real-time model evaluation](https://epiforecasts.io/eval-germany-sp-nowcasting/real-time/)                    | A report visualising and evaluating nowcasts from the various model configurations considered here in real-time.                                                                                                                                   |
| [Real-time method evaluation](https://epiforecasts.io/eval-germany-sp-nowcasting/real-time-method-comparison/) | A report visualising and evaluating nowcasts from the various methods (from this project and other groups) submitted to the [Germany nowcasting hub](https://covid19nowcasthub.de) in real-time.                                                   |
| [Project README](https://github.com/epiforecasts/eval-germany-sp-nowcasting)                                   | Overarching project README. Includes links to resources, a summary of key files, and reproducibility information.                                                                                                                                  |
| [Analysis pipeline](https://github.com/epiforecasts/eval-germany-sp-nowcasting/blob/main/_targets.md)          | The `targets` based analysis pipeline.                                                                                                                                                                                                             |
| [Analysis archive](https://github.com/epiforecasts/eval-germany-sp-nowcasting/releases/tag/latest)             | An archived version of the `_targets` directory. Download using `get_targets_archive()`.                                                                                                                                                           |
| [Data](https://github.com/epiforecasts/eval-germany-sp-nowcasting/blob/main/data/README.md)                    | Documentation for input data and summarised output from the analysis.                                                                                                                                                                              |
| [bin](https://github.com/epiforecasts/eval-germany-sp-nowcasting/blob/main/bin/README.md)                      | Documentation for orchestration of nowcast estimation, publishing, and archiving.                                                                                                                                                                  |
| [News](https://github.com/epiforecasts/eval-germany-sp-nowcasting/blob/main/NEWS.md)                           | Dated development notes.                                                                                                                                                                                                                           |
| [epinowcast](https://epiforecasts.io/epinowcast/index.html)                                                    | The documentation for `epinowcast` the R package used to implement the models evaluated here. See this [case study](https://epiforecasts.io/epinowcast/articles/germany-age-stratified-nowcasting.html) for a simplified version of this analysis. |
| [Germany nowcasting hub](https://covid19nowcasthub.de)                                                         | The homepage (containing a dashboard and information) for the Germany nowcasting hub project to which nowcasts from this evaluation are submitted along with others produced by independent groups.                                                |

## Key files and folders

| Folder/File                       | Purpose                                                                          |
|-----------------------------------|----------------------------------------------------------------------------------|
| [`writeup`](docs/)                | Summary paper and additional supplementary information as `Rmarkdown` documents. |
| [`_targets.Rmd`](_targets.Rmd)    | Analysis workflow for interactive use.                                           |
| [`R`](R/)                         | R functions used in the analysis and for evaluation.                             |
| [`data`](data/)                   | Input data and summarised output generated by steps in the analysis.             |
| [`.devcontainer`](.devcontainer/) | Resources for reproducibility using `vscode` and `docker`.                       |

## Dependencies

Dependencies are managed using \[`renv`\].

Alternatively a docker
[container](https://github.com/epiforecasts/simplfied-forecaster-evaluation/blob/main/.devcontainer/Dockerfile)
and
[image](https://github.com/epiforecasts/simplfied-forecaster-evaluation/pkgs/container/simplfied-forecaster-evaluation)
is provided. An easy way to make use of this is using the Remote
development extension of `vscode`.

## Analyses
