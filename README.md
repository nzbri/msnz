
<!-- README.md is generated from README.Rmd. Please edit that file -->

# msnz

The goal of the `msnz` package is to provide functions to simplify data
analysis from the New Zealand Multiple Sclerosis Prevalence and related
studies.

## Installation

This package is currently only of interest and utility at NZBRI and
hence won’t be made available via CRAN. Instead, it is hosted in a
repository on Github at <https://github.com/nzbri/msnz>

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
remotes::install_github('nzbri/chchpd@v0.2.0')
```
