
<!-- README.md is generated from README.Rmd. Please edit that file -->

# msnz

The goal of the `msnz` package is to provide functions to simplify data
analysis from the New Zealand Multiple Sclerosis Prevalence and related
studies, for researchers associated with the New Zealand Brain Research
Institute (NZBRI).

## Installation

This package is primarily of interest and utility at NZBRI and hence
won’t be made available via CRAN. Instead, it is hosted in a repository
on Github at <https://github.com/nzbri/msnz>

Therefore, the usual installation route using `install.packages('msnz')`
is not possible, and will yield a not-useful error message that the
package is not available for your version of R. Instead, install `msnz`
from its development repository on Github as follows:

``` r
# install.packages('remotes')
remotes::install_github('nzbri/msnz')
```

If `install_github('nzbri/msnz')` is invoked subsequently, the package
will be downloaded and installed only if the version on Github is newer
than the one installed locally.

If problems arise in a new release, you can downgrade to a previous
version by specifying the name of a particular release to revert to,
e.g.

``` r
remotes::install_github('nzbri/msnz@v0.3.0')
```

## Functions specific to the MS prevalence study

The package provides three convenience functions to extract info from
the the unique identifier (UNI) assigned to each participant (see
Richardson *et.al.* (2012) Method for identifying eligible individuals
for a prevalence survey in the absence of a disease register or
population register. *Internal Medicine Journal,* ***42,*** 1207-1212.):

``` r
msnz::dob_from_uin()
msnz::sex_from_uin()
msnz::initials_from_uin()
```

It also provides two package-wide constants, giving the original census
date of the New Zealand MS Prevalence study, and the censoring date for
survival analyses, set to 15 years later:

``` r
library(msnz)

msnz::census_date
#> [1] "2006-03-07"
msnz::censoring_date
#> [1] "2021-03-07"
```

## Calculating New Zealand life expectancy

This function is the only one of use more generally to external
researchers. The package incorporates the New Zealand Cohort Life Tables
provided by Statistics New Zealand, and as released in March 2021. (See
<https://www.stats.govt.nz/information-releases/new-zealand-cohort-life-tables-march-2022-update>
for source data).

The `msnz::expected_year_of_death()` function allows one to calculate
the life expectancy of a New Zealander, given their year of birth, sex,
and some conditional age (see below for explanation).

``` r
library(msnz)

msnz::expected_year_of_death(year_of_birth = 1970, 
                             sex = 'female', 
                             conditional_age = 50)
#> [1] 2058.5

# calculate life expectancy (in years from the conditional age year):
year_of_birth = 1970
conditional_age = 50

expected_year_of_death(year_of_birth = year_of_birth,
                       sex = 'female', 
                       conditional_age = conditional_age) - 
  (year_of_birth + conditional_age) # = 2020
#> [1] 38.5
```

It is important to specify a conditional age that the person has
reached. If `0`, then the returned value will reflect life expectancy at
birth. For example, the expected year of death of a person is greater if
it is known that they have managed to reach a given age, compared to
their life expectancy at birth (when they would be subject to child
mortality and early adulthood risks):

``` r
# life expectancy at birth, which is subject to infant mortality and elevated 
# risks in teenage years/early adulthood (e.g. traffic accidents and suicide):
msnz::expected_year_of_death(year_of_birth = 1970, 'female', 
                             conditional_age = 0)
#> [1] 2055.2

# given that we know that a person has lived to a certain age, their expected 
# year of death should be greater, as they have survived through a period of
# mortality risks:
msnz::expected_year_of_death(year_of_birth = 1970, 'female', 
                             conditional_age = 50)
#> [1] 2058.5
```

The values returned can either be deterministic (extracted directly from
the life table) or the result of a random sampling process (to better
simulate the distribution of values that would be seen in an actual
population). The sampling approach is particularly useful in a survival
analysis where one wishes to compare the survival in a given sample
against a synthetic sample derived from the population. That is, for
each person in the actual sample, generate a synthetic comparison person
randomly sampled from the population, conditional on the target person’s
year of birth, sex, and age at a censoring date. The sampling approach
gives a much more natural looking comparison sample survival
distribution, compared to each synthetic person having precisely the
median survival conditional on those values.
