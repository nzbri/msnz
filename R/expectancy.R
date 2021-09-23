# Look up the NZ cohort life tables for an expected or randomly sampled
# year of death.
#
# This hidden function checks only one scalar value. See the exported,
# vector-safe expected_year_of_death() function for documentation.

.expected_year_of_death <- function(year_of_birth,
                                    sex,
                                    conditional_age,
                                    conditional_age_default = 39,
                                    method = 'median',
                                    percentile = 'median') {

  # some patients might not have the conditional age defined. If so, substitute
  # a default value:
  if (is.na(conditional_age)) {conditional_age = conditional_age_default}

  if (method == 'median') {

    expectation = nz_life_table %>%
      dplyr::filter(yearofbirth == year_of_birth,
                    sex == !!sex, # unquote, as argument & column have same name
                    age == conditional_age,
                    percentile == !!percentile) # unquote again

    additional_years_lived = expectation$ex

  }
  else if (method == 'sample') {

    additional_years_lived = 0
    alive = 1

    # Get the probabilities for a person of the relevant birth year and sex
    life_table_subset = nz_life_table %>%
      dplyr::filter(yearofbirth == year_of_birth,
                    sex == !!sex, # unquote, as argument & column have same name
                    percentile == !!percentile) # unquote again

    while (alive) {

      # life tables only go up to 100:
      lifetables_age = min(conditional_age + additional_years_lived, 100)

      expectation = life_table_subset %>%
        dplyr::filter(age == lifetables_age)

      # run simulation to see if they live another year.
      # px is the probability that they live another year:
      if (runif(1) <= expectation$px) {
        additional_years_lived = additional_years_lived + 1
        # Didn't survive year, are now deceased:
      } else {
        alive = 0
      }

    }

  } else {
    stop("The 'method' parameter must be one of 'median' or 'sample'")
  }

  # make as.numeric to avoid returning a tiny dataframe:
  return(as.numeric(year_of_birth + conditional_age + additional_years_lived))
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
#' @param conditional_age Conditional age as an integer. We use this so that
#' the expected age of death is conditional on having reached this age,
#' rather than being calculated from the value at birth. If the conditional
#' age is \code{NA}, then conditional_age_default is substituted for it.
#'
#' @param conditional_age_default The default conditional age to use when
#' conditional age is \code{NA}. Defaults to 39.
#'
#' @param method Specify whether to give the \code{'median'} life
#' expectancy (the default), or \code{'sample'} from the distribution defined
#' by the median life expectancy and the variance around this. While the other
#' arguments can be vectors of multiple values, this is a single value that
#' applies to everything.
#'
#' @param percentile When returning the median life expectancy, specify whether
#' to return the \code{'median'} estimate of this value (the default), or
#' \code{'5'} or \code{'95'} for the 5th or 95th percentile. While other
#' arguments can be vectors of multiple values, this is a single value that
#' applies to everything.
#'
#' @param n_samples When the method is \code{'sample'}, specify how many samples
#' to return for each individual. Defaults to 1. While other arguments can
#' be vectors of multiple values, this is a single value that applies to
#' everything.
#'
#' @param seed When the method is \code{'sample'}, for reproducibility, this
#' integer parameter allows you to specify a seed to the random number generator
#' so that the random sample values generated will be consistent from one run to
#' another. Defaults to \code{NULL}, meaning that the sample values returned
#' will vary across calls to the function.
#'
#' @return \code{'YYYY.Y'} The expected year of death (numeric).
#'
#' @export
expected_year_of_death <- function(year_of_birth,
                                   sex,
                                   conditional_age,
                                   conditional_age_default = 39,
                                   method = 'median',
                                   percentile = 'median',
                                   n_samples = 1,
                                   seed = NULL
) {

  # allow for reproducibility of random sampling across runs:
  if (!is.null(seed)) {set.seed(seed)}

  # allow for more than one value to be processed:
  n = length(year_of_birth)
  result = rep(NA, n*n_samples) # create n_samples * length vector to return

  for (i in 1:n) {
    for (j in 1:n_samples) {
      result[j + (i - 1) * n_samples] =
        .expected_year_of_death(year_of_birth = year_of_birth[i],
                                sex = sex[i],
                                conditional_age = conditional_age[i],
                                method = method,
                                percentile = percentile)
    }
  }

  return(result)
}

