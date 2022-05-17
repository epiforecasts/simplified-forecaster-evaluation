# 2022-02-11

- Reduce adapt delta to 0.95 from 0.99 as no longer required due to the use of a secondary model (introduced on the `2022-02-09`) for problematic fits.
- Added an `allow_empty` arguement to `save_csv` to prevent the saving of emtpy targets (due to upstream errors in most cases). This prevents `csv` targets from being wrongfully blocked from updating when these issues are resolved.

# 2022-02-10

- Reduce fitting failure threshold to an Rhat of 1.5 or higher.
- Process both daily and 7 day nowcasts with the same bounding on samples being greater than confirmed cases.

# 2022-02-09

- Due to recent instability in fitting the adapt delta setting has been updated from 0.95 to 0.99. This increases model fitting time but may also improve the quality of model fits.
- Updated `adjust_quantile()` to limit quantiles for problematic model fits to be bounded at plus/minus 25% of the median value (rather than + 25% and -75% as was previously the case).
- Redefine a fitting failure as being if the maximum Rhat is greater than 3. If this occurs then fit a nowcast with a fixed delay distribution instead.
- Added additional postprocessing so that if samples are `NA` or less than the daily reported value they are set to the reported value.

# 2022-01-31

- Widen the prior used for reporting delay distribution from 5 times to 10 times that estimated nationally using data as reported on the 1st of July 2021. 
- Corrected the lower bound quantile adjustment for models with fitting issues to correctly replace it with a lower bound and not the upper bound as previously.
- Added a fallback option to fit the default model (fixed lognormal delays) in the case where fitting fails for a given model. Added a flag for this happening and included saving this information in fitting diagnostic folder.

# 2022-01-21

- Dropped the first nowcast (from the 24th of November 2021) from the RKI-weekly_report model from all stratified evaluatioon as this was the only nowcast for which estimates were made for the day of nowcast and the subsequent two days from this model, performance was poor, and this masked other meaningful between model differences.

- Dropped the SZ-hosp_nowcast model from all stratified performance evaluation due to it masking other meaningful between model differences. 

# 2022-01-05

- Fixed a bug which meant that the 10% quantile was not included in posterior predictions. In order to avoid refitting all models this quantile has been excluded from evaluation and the `targets` pipeline has been updated so that models are never refit.

# 2021-12-06

- Added a new model that is the same as the baseline independent model but that also includes a day of the week adjustment for the date of positive test. From today this model is used as the hub submission model instead of the original independent model. This change is based on backtesting to the 1st of October which showed an approximate 10% increase in both absolute and relative performance for the 0 to -7 horizons across all groups excluding the 5-14 year olds where performance was slightly degraded. This change will be monitored over the next few weeks to make sure the performance improvement is stable. The only downside is a roughly 100% increase in model estimation times but this is still well within the available compute.
- This change impacts both national age stratified nowcasts and state level nowcasts.
- Updated documentation to reflect the change to the submission model.
- Updated the `targets` tracking to never rebuild nowcast submissions if already present to prevent overwriting past nowcast submissions when models are changed.

# 2021-12-3

- Fix plotting in reports so that more than 7 models/methods can be shown.
- Adds caching to documentation rendering to prevent all forecasts being downloaded each time documentation is built.

# 2021-12-01

- Added tools to access nowcasts submitted to the Germany nowcasting hub
- Added tools to allow the evaluation approach used in this project to be applied to the nowcasts from the Germany nowcasting hub.
- Added an overall score summary plot

# 2021-11-24

- Added README's for the data and bash script folders. 
- Added retrospective nowcasts back to the 15th of October 2021.

# 2021-11-23

- Added an introduction and methods write up. 
- Added a real-time evaluation report skeleton.
- Added additional repository and project details to the README.
- Added a home page to the published reports webpage linking to resources.

# 2021-11-20

- Added a initial framework for reporting the nowcast results.
- Added a simple adjustment for spuriously large or small quantiles when models have had issues with fitting. This is simply a rescaling of quantiles that are greater/smaller than 25% of the median.

# 2021-11-19

- Simplified the model with an age grouped random walk to have independent random walks by age rather than a shared global walk and a group specific random walk in the residuals. This was based on initial backcasting where the more complex model was unstable during fitting indicating issues with the model formulation.

# 2021-11-17

- Add targets workflow for processing new data.
- Add targets workflow for nowcasting using a range of models.
- Add targets workflow for formatting nowcasts and added nowcast metadata.

# 2021-10-26

- Initial version of semi-parametric nowcasting model with flexible date of reference and date of report effects implemented in stan with supporting R parsing code.

# 2021-10-17

- Set up project and imported key files from `{EpiNow2}`.
