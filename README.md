
<!-- README.md is generated from README.Rmd. Please edit that file -->

# slap

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/slap)](https://CRAN.R-project.org/package=slap)
[![R-CMD-check](https://github.com/tadascience/slap/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tadascience/slap/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of slap is to …

## Installation

You can install the development version of slap like so:

``` r
pak::pak("tadascience/slap")
```

## Example

``` r
library(dplyr)
library(slap)

boom <- function() stop("ouch")

# instead of:
withCallingHandlers(
  summarise(mtcars, mpg = boom()), 
  error = function(err) {
    cli::cli_abort("ouch", parent = err)
  }
)

# just use the slap operator, i.e. %!%
summarise(mtcars, mpg = boom()) %!% "ouch" 
```
