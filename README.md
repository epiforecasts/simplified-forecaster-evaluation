
# Evaluating Semi-Parametric Nowcasts of COVID-19 Hospital Admissions in Germany

This repository contains the documentation, results, and code of a
project evaluating the use of a semi-parametric nowcasting approach for
COVID-19 hospitalisations in Germany. See the documentation for further
details. This project is part of a [wider
collaboration](https://covid19nowcasthub.de) assessing a range of
nowcasting methods whilst providing an ensemble nowcast of COVID-19
Hospital admissions in Germany by date of positive test. This ensemble
should be used for any policy related work rather than the nowcasts
provided in this repository. See [here](https://covid19nowcasthub.de)
for more on this nowcasting collaboration.

## Citation

If making use of the results of this analysis or reusing the analysis
pipeline please cite:

If making using of the models evaluated in this analysis please also
cite [`epinowcast`](https://epiforecasts.io/epinowcast):

> Sam Abbott (2021). epinowcast: Hierarchical nowcasting of right
> censored epidemological counts, DOI: 10.5281/zenodo.5637165

A BibTeX entry for LaTeX users is also available:

@Article{, title = {epinowcast: Hierarchical nowcasting of right
censored epidemological counts}, author = {Sam Abbott}, journal =
{Zenodo}, year = {2021}, doi = {10.5281/zenodo.5637165}, }

## Documentation

| Document                                                                                                       | Purpose                                                                                                                                                                                                                                            |
| -------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
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

| Folder/File                       | Purpose                                                                                                                                                 |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`writeup`](writeup/)             | Summary paper and additional supplementary information as `Rmarkdown` documents.                                                                        |
| [`_targets.Rmd`](_targets.Rmd)    | Analysis workflow for interactive use.                                                                                                                  |
| [`R`](R/)                         | R functions used in the analysis and for evaluation.                                                                                                    |
| [`data`](data/)                   | Input data and summarised output generated by steps in the analysis.                                                                                    |
| [`analyses`](analyses/)           | Ad-hoc analyses not part of the overarching workflow. This includes a synthetic case study and a simplified example using Germany hospitalisation data. |
| [`.devcontainer`](.devcontainer/) | Resources for reproducibility using `vscode` and `docker`.                                                                                              |

## Dependencies

All dependencies can be installed using the following,

``` r
remotes::install_dev_deps()
```

Alternatively a docker
[container](https://github.com/epiforecasts/eval-germany-sp-nowcasting/blob/main/.devcontainer/Dockerfile)
and
[image](https://github.com/epiforecasts/eval-germany-sp-nowcasting/pkgs/container/eval-germany-sp-nowcasting)
is provided. An easy way to make use of this is using the Remote
development extension of `vscode`.

## Analyses

This analysis in this repository has been implemented using the
[`targets`](https://docs.ropensci.org/targets/) package and associated
packages. The workflow is defined in
[`_targets.md`](https://github.com/epiforecasts/eval-germany-sp-nowcasting/blob/main/_targets.md)
and can be explored interactively using
[`_targets.Rmd`](https://github.com/epiforecasts/eval-germany-sp-nowcasting/blob/main/_targets.Rmd)
`Rmarkdown` document. The workflow can be visualised as the following
graph.

![](figures/targets-graph.png)

This complete analysis can be recreated using the following (note this
may take quite some time even with a fairly large amount of available
compute),

``` bash
bash bin/update-targets.sh
```

Alternative the following `targets` functions may be used to
interactively explore the workflow:

  - Run the workflow sequentially.

<!-- end list -->

``` r
targets::tar_make()
```

  - Run the workflow using all available workers.

<!-- end list -->

``` r
targets::tar_make_future(workers = future::availableCores())
```

  - Explore a graph of the workflow.

<!-- end list -->

``` r
targets::tar_visnetwork(targets_only = TRUE)
```

Watch the workflow as it runs in a `shiny` app.

``` r
targets::tar_watch(targets_only = TRUE)
```

To use our archived version of the interim results (and so avoid long
run times) use the following to download it. Note that this process has
not been rigorously tested across environments and so may not work
seamlessly).

``` r
source(here::here("R", "targetss-archive.R"))
get_targets_archive()
```
