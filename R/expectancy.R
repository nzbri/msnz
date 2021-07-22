# Check an NHI for being in a correct format.
#
# This hidden function checks only one scalar value. See the exported,
# vector-safe nhi_format() function for documentation.
#

.expected_year_of_death <- function(year_of_birth,
                                   sex,
                                   age_at_diagnosis,
                                   percentile = 'median') {

  ex = nz_life_table %>%
    dplyr::filter(yearofbirth == year_of_birth,
                  sex == !!sex, # unquote, as argument & column have same name
                  age == age_at_diagnosis,
                  percentile == !!percentile) %>% # unquote again
    dplyr::select(ex)

  # as.numeric to avoid returning a tiny dataframe:
  expected_year_of_death = as.numeric(year_of_birth + age_at_diagnosis + ex)

  return(expected_year_of_death)
}

#' Get expected year of death.
#'
#' \code{expected_year_of_death} Look up the NZ cohort life tables for a person
#' of the specified year of birth, sex, and age at diagnosis, and return the
#' expected year of death.
#'
#' @param year_of_birth Year of birth as an integer.
#'
#' @param sex A character variable containing either \code{female} or
#' \code{male}.
#'
#' @param age_at_diagnosis Age at diagnosis as an integer. We use this so that
#' the expected age of death is conditional on having reached the age of
#' diagnosis, rather than being calculated from the value at birth.
#'
#' @param percentile Specify whether to return the \code{'median'} estimate (the
#' default), or \code{'5'} or \code{'95'} for the 5th or 95th percentile. While
#' the other arguments can be vectors of multiple values, this is a single value
#' that applies to everything.
#'
#' @return \code{'YYYY.Y'} The expected year of death (numeric).
#'
#' @export
expected_year_of_death <- function(year_of_birth,
                                   sex,
                                   age_at_diagnosis,
                                   percentile = 'median') {

  # allow for more than one value to be processed:
  n = length(year_of_birth)
  result = rep(NA, n) # create a same-length vector to return

  for (i in 1:n) {
    result[i] = .expected_year_of_death(year_of_birth = year_of_birth[i],
                                        sex = sex[i],
                                        age_at_diagnosis = age_at_diagnosis[i],
                                        percentile = percentile)
  }

  return(result)
}

