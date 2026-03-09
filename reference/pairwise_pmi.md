# Pointwise mutual information of pairs of items

Find pointwise mutual information of pairs of items in a column, based
on a "feature" column that links them together. This is an example of
the spread-operate-retidy pattern.

## Usage

``` r
pairwise_pmi(tbl, item, feature, sort = FALSE, ...)

pairwise_pmi_(tbl, item, feature, sort = FALSE, ...)
```

## Arguments

- tbl:

  Table

- item:

  Item to compare; will end up in `item1` and `item2` columns

- feature:

  Column describing the feature that links one item to others

- sort:

  Whether to sort in descending order of the pointwise mutual
  information

- ...:

  Extra arguments passed on to `squarely`, such as `diag` and `upper`

## Value

A tbl_df with three columns, `item1`, `item2`, and `pmi`.

## Examples

``` r
library(dplyr)

dat <- tibble(group = rep(1:5, each = 2),
              letter = c("a", "b",
                         "a", "c",
                         "a", "c",
                         "b", "e",
                         "b", "f"))

# how informative is each letter about each other letter
pairwise_pmi(dat, letter, group)
#> # A tibble: 8 × 3
#>   item1 item2    pmi
#>   <chr> <chr>  <dbl>
#> 1 b     a     -0.588
#> 2 c     a      0.511
#> 3 a     b     -0.588
#> 4 e     b      0.511
#> 5 f     b      0.511
#> 6 a     c      0.511
#> 7 b     e      0.511
#> 8 b     f      0.511
pairwise_pmi(dat, letter, group, sort = TRUE)
#> # A tibble: 8 × 3
#>   item1 item2    pmi
#>   <chr> <chr>  <dbl>
#> 1 c     a      0.511
#> 2 e     b      0.511
#> 3 f     b      0.511
#> 4 a     c      0.511
#> 5 b     e      0.511
#> 6 b     f      0.511
#> 7 b     a     -0.588
#> 8 a     b     -0.588
```
