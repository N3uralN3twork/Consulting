Randomization Schema
================
Matthias Quinn

[![Creator](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://github.com/N3uralN3twork)
[![RStudio Community:
Teaching](https://img.shields.io/endpoint?url=https%3A%2F%2Frstudio.github.io%2Frstudio-shields%2Fcategory%2Fteaching.json)](https://community.rstudio.com/c/teaching)
[![GPLv3
license](https://img.shields.io/badge/License-GPLv3-blue.svg)](http://perso.crans.org/besson/LICENSE.html)

# Overview

This package was created as part of a series of projects in a
programming class that I took in the Fall of 2020. There is only one
function so far for this package, and that is `schema`.

Completely Randomized Block Design

  - `schema`: Creates a design matrix given various schema inputs

# How to Install

``` r
library(devtools)
devtools::install_github("N3uralN3twork/Consulting/Randomizations", INSTALL_opts=c("--no-multiarch"))
```

# Instructions for Use

1.  Load the library using the `library` function in base R

2.  Input the number / site codes you would like (up to 26)

3.  Input the number of subjects per site

4.  Input the number of subjects assigned to each block

5.  Input the randomization ratio used to assign treatment/control
    groups

6.  \[Optional\] Decide whether you would like to reproduce your result

7.  Run the program

# Example :mortar\_board:

``` r
library(Randomizations)
library(knitr)

schema(Sites = 1, NSubjects = 10, BlockSize = 6, RRatio = 1, seed = TRUE) %>%
  kable()
```

| Code   | Site | Subject | Group |
| :----- | :--- | :------ | :---- |
| AAA01T | AAA  | 01      | T     |
| AAA02C | AAA  | 02      | C     |
| AAA03T | AAA  | 03      | T     |
| AAA04C | AAA  | 04      | C     |
| AAA05C | AAA  | 05      | C     |
| AAA06C | AAA  | 06      | C     |
| AAA07T | AAA  | 07      | T     |
| AAA08C | AAA  | 08      | C     |
| AAA09T | AAA  | 09      | T     |
| AAA10T | AAA  | 10      | T     |

# Resources :notebook:

[Table
Options](https://stackoverflow.com/questions/44504759/shiny-r-download-the-result-of-a-table)

[Pretty
Options](https://rdrr.io/cran/shinyWidgets/man/prettyCheckboxGroup.html)

[Shiny
Tutorial](https://shiny.rstudio.com/tutorial/written-tutorial/lesson2/)

[FOR Loops in R](https://www.datamentor.io/r-programming/for-loop/)

[Substrings in
R](https://statisticsglobe.com/r-extract-first-or-last-n-characters-from-string)

[rep() in
R](https://astrostatistics.psu.edu/su07/R/html/base/html/rep.html)

[Boolean &&
Operator](https://stackoverflow.com/questions/6558921/boolean-operators-and?noredirect=1&lq=1)

[Multi-user Input in
Shiny](https://rdrr.io/cran/shinyWidgets/man/multiInput.html)

[Making an R
Package](https://tinyheero.github.io/jekyll/update/2015/07/26/making-your-first-R-package.html)

[Negation in
R](https://stackoverflow.com/questions/38351820/negation-of-in-in-r)
