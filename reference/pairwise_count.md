# Count pairs of items within a group

Count the number of times each pair of items appear together within a
group defined by "feature." For example, this could count the number of
times two words appear within documents).

## Usage

``` r
pairwise_count(tbl, item, feature, wt = NULL, ...)

pairwise_count_(tbl, item, feature, wt = NULL, ...)
```

## Arguments

- tbl:

  Table

- item:

  Item to count pairs of; will end up in `item1` and `item2` columns

- feature:

  Column within which to count pairs `item2` columns

- wt:

  Optionally a weight column, which should have a consistent weight for
  each feature

- ...:

  Extra arguments passed on to `squarely`, such as `diag`, `upper`, and
  `sort`

## See also

[`squarely()`](https://juliasilge.github.io/widyr/reference/squarely.md)

## Examples

``` r
library(dplyr)
dat <- tibble(group = rep(1:5, each = 2),
              letter = c("a", "b",
                         "a", "c",
                         "a", "c",
                         "b", "e",
                         "b", "f"))

# count the number of times two letters appear together
pairwise_count(dat, letter, group)
#> # A tibble: 8 × 3
#>   item1 item2     n
#>   <chr> <chr> <dbl>
#> 1 b     a         1
#> 2 c     a         2
#> 3 a     b         1
#> 4 e     b         1
#> 5 f     b         1
#> 6 a     c         2
#> 7 b     e         1
#> 8 b     f         1
pairwise_count(dat, letter, group, sort = TRUE)
#> # A tibble: 8 × 3
#>   item1 item2     n
#>   <chr> <chr> <dbl>
#> 1 c     a         2
#> 2 a     c         2
#> 3 b     a         1
#> 4 a     b         1
#> 5 e     b         1
#> 6 f     b         1
#> 7 b     e         1
#> 8 b     f         1
pairwise_count(dat, letter, group, sort = TRUE, diag = TRUE)
#> # A tibble: 13 × 3
#>    item1 item2     n
#>    <chr> <chr> <dbl>
#>  1 a     a         3
#>  2 b     b         3
#>  3 c     a         2
#>  4 a     c         2
#>  5 c     c         2
#>  6 b     a         1
#>  7 a     b         1
#>  8 e     b         1
#>  9 f     b         1
#> 10 b     e         1
#> 11 e     e         1
#> 12 b     f         1
#> 13 f     f         1
```
