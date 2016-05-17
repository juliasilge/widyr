<!-- README.md is generated from README.Rmd. Please edit that file -->



### widyr: Widen, process, and re-tidy a dataset

**License:** [MIT](https://opensource.org/licenses/MIT)

[![Travis-CI Build Status](https://travis-ci.org/.svg?branch=master)](https://travis-ci.org/)
[![Coverage Status](https://img.shields.io/codecov/c/github//master.svg)](https://codecov.io/github/?branch=master)

This package wraps the pattern of un-tidying data into a wide matrix, performing some processing, then turning it back into a tidy form. This is useful for several mathematical operations such as co-occurence counts, correlations, or clustering that are best done on a wide matrix.

### Installation

Install from Github with [devtools](https://github.com/hadley/devtools):


```r
library(devtools)
install_github("dgrtwo/widyr")
```

### Examples

#### Pair functions

The package has pre-wrapped some common functions that operate on pairs of items. For example, suppose we have a text dataset.


```r
library(dplyr)
library(tidytext)
library(stringr)
library(janeaustenr)

w <- data_frame(text = prideprejudice) %>%
  mutate(chapter = cumsum(str_detect(text, "^Chapter"))) %>%
  ungroup() %>%
  unnest_tokens(word, text) %>%
  filter(chapter > 0, !(word %in% stop_words$word))

w
#> Source: local data frame [37,242 x 2]
#> 
#>    chapter         word
#>      (int)        (chr)
#> 1        1      chapter
#> 2        1            1
#> 3        1        truth
#> 4        1  universally
#> 5        1 acknowledged
#> 6        1       single
#> 7        1   possession
#> 8        1      fortune
#> 9        1         wife
#> 10       1     feelings
#> ..     ...          ...

# words used at least 10 times
w_count <- w %>%
  count(word, chapter) %>%
  filter(sum(n) >= 10) %>%
  ungroup()
```

We can then find words that tend to co-appear:


```r
w_count %>%
  pair_cor(chapter, word, n, sort = TRUE)
#> Source: local data frame [742,182 x 3]
#> 
#>          item1       item2 correlation
#>          (chr)       (chr)       (dbl)
#> 1           de      bourgh   0.9800135
#> 2       bourgh          de   0.9800135
#> 3     reynolds housekeeper   0.9721131
#> 4  housekeeper    reynolds   0.9721131
#> 5     reynolds      master   0.9473136
#> 6       master    reynolds   0.9473136
#> 7       master housekeeper   0.9464619
#> 8  housekeeper      master   0.9464619
#> 9     reynolds     picture   0.9395403
#> 10     picture    reynolds   0.9395403
#> ..         ...         ...         ...
```

If we don't want to include duplicates, we can add `upper = FALSE` (in that we are no longer including the "upper triangle" of the correlation):


```r
w_count %>%
  pair_cor(chapter, word, n, sort = TRUE, upper = FALSE)
#> Source: local data frame [371,091 x 3]
#> 
#>          item1    item2 correlation
#>          (chr)    (chr)       (dbl)
#> 1       bourgh       de   0.9800135
#> 2  housekeeper reynolds   0.9721131
#> 3       master reynolds   0.9473136
#> 4  housekeeper   master   0.9464619
#> 5      picture reynolds   0.9395403
#> 6  housekeeper  picture   0.9217574
#> 7       master  picture   0.9020628
#> 8    catherine     lady   0.8964611
#> 9       dances  partner   0.8921980
#> 10     dancing  partner   0.8805563
#> ..         ...      ...         ...
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
