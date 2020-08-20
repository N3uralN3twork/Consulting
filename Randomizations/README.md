Randomization Schema
================
Matthias Quinn

[![Creator](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://github.com/N3uralN3twork)

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

# Example

``` r
library(Randomizations)
library(knitr)

schema(Sites = 1, NSubjects = 10, BlockSize = 6, RRatio = 1, seed = TRUE) %>%
  kable()
```

| Code   | Site | Subject | Group |
| :----- | :--- | :------ | :---- |
| AAA01C | AAA  | 01      | C     |
| AAA02T | AAA  | 02      | T     |
| AAA03C | AAA  | 03      | C     |
| AAA04T | AAA  | 04      | T     |
| AAA05T | AAA  | 05      | T     |
| AAA06T | AAA  | 06      | T     |
| AAA07T | AAA  | 07      | T     |
| AAA08C | AAA  | 08      | C     |
| AAA09C | AAA  | 09      | C     |
| AAA10C | AAA  | 10      | C     |
