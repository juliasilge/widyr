# Distances of pairs of items

Compute distances of all pairs of items in a tidy table.

## Usage

``` r
pairwise_dist(tbl, item, feature, value, method = "euclidean", ...)

pairwise_dist_(tbl, item, feature, value, method = "euclidean", ...)
```

## Arguments

- tbl:

  Table

- item:

  Item to compare; will end up in `item1` and `item2` columns

- feature:

  Column describing the feature that links one item to others

- value:

  Value

- method:

  Distance measure to be used; see
  [`dist()`](https://rdrr.io/r/stats/dist.html)

- ...:

  Extra arguments passed on to
  [`squarely()`](https://juliasilge.github.io/widyr/reference/squarely.md),
  such as `diag` and `upper`

## See also

[`squarely()`](https://juliasilge.github.io/widyr/reference/squarely.md)

## Examples

``` r
library(gapminder)
library(dplyr)

# closest countries in terms of life expectancy over time
closest <- gapminder |>
  pairwise_dist(country, year, lifeExp) |>
  arrange(distance)

closest
#> # A tibble: 20,022 × 3
#>    item1          item2          distance
#>    <fct>          <fct>             <dbl>
#>  1 Germany        Belgium            1.08
#>  2 Belgium        Germany            1.08
#>  3 United Kingdom New Zealand        1.51
#>  4 New Zealand    United Kingdom     1.51
#>  5 Norway         Netherlands        1.56
#>  6 Netherlands    Norway             1.56
#>  7 Italy          Israel             1.66
#>  8 Israel         Italy              1.66
#>  9 Finland        Austria            1.94
#> 10 Austria        Finland            1.94
#> # ℹ 20,012 more rows

closest |>
  filter(item1 == "United States")
#> # A tibble: 141 × 3
#>    item1         item2          distance
#>    <fct>         <fct>             <dbl>
#>  1 United States Belgium            2.09
#>  2 United States Germany            2.48
#>  3 United States United Kingdom     2.51
#>  4 United States Ireland            2.99
#>  5 United States New Zealand        3.69
#>  6 United States Finland            3.76
#>  7 United States Austria            4.18
#>  8 United States Greece             4.30
#>  9 United States France             4.63
#> 10 United States Denmark            5.26
#> # ℹ 131 more rows

# to remove duplicates, use upper = FALSE
gapminder |>
  pairwise_dist(country, year, lifeExp, upper = FALSE) |>
  arrange(distance)
#> # A tibble: 10,011 × 3
#>    item1       item2          distance
#>    <fct>       <fct>             <dbl>
#>  1 Belgium     Germany            1.08
#>  2 New Zealand United Kingdom     1.51
#>  3 Netherlands Norway             1.56
#>  4 Israel      Italy              1.66
#>  5 Austria     Finland            1.94
#>  6 Belgium     United Kingdom     1.95
#>  7 Iceland     Sweden             2.01
#>  8 Comoros     Mauritania         2.01
#>  9 Belgium     United States      2.09
#> 10 Germany     Ireland            2.10
#> # ℹ 10,001 more rows

# Can also use Manhattan distance
gapminder |>
  pairwise_dist(country, year, lifeExp, method = "manhattan", upper = FALSE) |>
  arrange(distance)
#> # A tibble: 10,011 × 3
#>    item1       item2          distance
#>    <fct>       <fct>             <dbl>
#>  1 Belgium     Germany            3.17
#>  2 New Zealand United Kingdom     4.40
#>  3 Netherlands Norway             4.57
#>  4 Belgium     United Kingdom     4.87
#>  5 Israel      Italy              5.17
#>  6 Austria     Finland            5.28
#>  7 Comoros     Mauritania         5.51
#>  8 Greece      Italy              5.73
#>  9 Belgium     United States      5.94
#> 10 France      Italy              6.02
#> # ℹ 10,001 more rows
```
