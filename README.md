<!-- README.md is generated from README.Rmd. Please edit that file -->



### widyr: Widen, process, and re-tidy a dataset

**License:** [MIT](https://opensource.org/licenses/MIT)

[![Travis-CI Build Status](https://travis-ci.org/widyr.svg?branch=master)](https://travis-ci.org/dgrtwo/widyr)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/dgrtwo/widyr?branch=master&svg=true)](https://ci.appveyor.com/project/dgrtwo/widyr)
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
#> Error in function_list[[k]](value): could not find function "pair_cor"
```

If we don't want to include duplicates, we can add `upper = FALSE` (in that we are no longer including the "upper triangle" of the correlation):


```r
w_count %>%
  pair_cor(chapter, word, n, sort = TRUE, upper = FALSE)
#> Error in function_list[[k]](value): could not find function "pair_cor"
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
