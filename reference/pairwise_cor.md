# Correlations of pairs of items

Find correlations of pairs of items in a column, based on a "feature"
column that links them together. This is an example of the
spread-operate-retidy pattern.

## Usage

``` r
pairwise_cor(
  tbl,
  item,
  feature,
  value,
  method = c("pearson", "kendall", "spearman"),
  use = "everything",
  ...
)

pairwise_cor_(
  tbl,
  item,
  feature,
  value,
  method = c("pearson", "kendall", "spearman"),
  use = "everything",
  ...
)
```

## Arguments

- tbl:

  Table

- item:

  Item to compare; will end up in `item1` and `item2` columns

- feature:

  Column describing the feature that links one item to others

- value:

  Value column. If not given, defaults to all values being 1 (thus a
  binary correlation)

- method:

  Correlation method

- use:

  Character string specifying the behavior of correlations with missing
  values; passed on to `cor`

- ...:

  Extra arguments passed on to `squarely`, such as `diag` and `upper`

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
library(gapminder)

gapminder |>
  pairwise_cor(country, year, lifeExp)
#> # A tibble: 20,022 × 3
#>    item1      item2       correlation
#>    <fct>      <fct>             <dbl>
#>  1 Albania    Afghanistan       0.966
#>  2 Algeria    Afghanistan       0.987
#>  3 Angola     Afghanistan       0.986
#>  4 Argentina  Afghanistan       0.971
#>  5 Australia  Afghanistan       0.939
#>  6 Austria    Afghanistan       0.956
#>  7 Bahrain    Afghanistan       0.996
#>  8 Bangladesh Afghanistan       0.947
#>  9 Belgium    Afghanistan       0.963
#> 10 Benin      Afghanistan       0.997
#> # ℹ 20,012 more rows

gapminder |>
  pairwise_cor(country, year, lifeExp, sort = TRUE)
#> # A tibble: 20,022 × 3
#>    item1              item2              correlation
#>    <fct>              <fct>                    <dbl>
#>  1 Mauritania         Indonesia                1.000
#>  2 Indonesia          Mauritania               1.000
#>  3 Senegal            Morocco                  1.000
#>  4 Morocco            Senegal                  1.000
#>  5 West Bank and Gaza Saudi Arabia             1.000
#>  6 Saudi Arabia       West Bank and Gaza       1.000
#>  7 France             Brazil                   0.999
#>  8 Brazil             France                   0.999
#>  9 Reunion            Bahrain                  0.999
#> 10 Bahrain            Reunion                  0.999
#> # ℹ 20,012 more rows

# United Nations voting data
if (require("unvotes", quietly = TRUE)) {
  country_cors <- un_votes |>
    mutate(vote = as.numeric(vote)) |>
    pairwise_cor(country, rcid, vote, sort = TRUE)
}
#> If you use data from the unvotes package, please cite the following:
#> 
#> Erik Voeten "Data and Analyses of Voting in the UN General Assembly" Routledge Handbook of International Organization, edited by Bob Reinalda (published May 27, 2013)
```
