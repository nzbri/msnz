# define some package-wide variables:

# the census date of the New Zealand MS Prevalence study:
#' @export
census_date = lubridate::ymd('2006-03-07')

# the censoring date for survival analyses, set to 15 years after the census
# date:
#' @export
censoring_date = lubridate::ymd('2021-03-07')
