# A special case of the widely adverb for creating tidy square matrices

A special case of
[`widely()`](https://juliasilge.github.io/widyr/reference/widely.md).
Used to pre-prepare and post-tidy functions that take an m x n (m items,
n features) matrix and return an m x m (item x item) matrix, such as a
distance or correlation matrix.

## Usage

``` r
squarely(.f, diag = FALSE, upper = TRUE, ...)

squarely_(.f, diag = FALSE, upper = TRUE, ...)
```

## Arguments

- .f:

  Function to wrap

- diag:

  Whether to include diagonal (i = j) in output

- upper:

  Whether to include upper triangle, which may be duplicated

- ...:

  Extra arguments passed on to `widely`

## Value

Returns a function that takes at least four arguments:

- tbl:

  A table

- item:

  Name of column to use as rows in wide matrix

- feature:

  Name of column to use as columns in wide matrix

- feature:

  Name of column to use as values in wide matrix

- ...:

  Arguments passed on to inner function

## See also

[`widely()`](https://juliasilge.github.io/widyr/reference/widely.md),
[`pairwise_count()`](https://juliasilge.github.io/widyr/reference/pairwise_count.md),
[`pairwise_cor()`](https://juliasilge.github.io/widyr/reference/pairwise_cor.md),
[`pairwise_dist()`](https://juliasilge.github.io/widyr/reference/pairwise_dist.md)

## Examples

``` r
library(dplyr)
library(gapminder)

closest_continent <- gapminder %>%
  group_by(continent) %>%
  squarely(dist)(country, year, lifeExp)
```
