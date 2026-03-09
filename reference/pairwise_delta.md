# Delta measure of pairs of documents

Compute the delta distances (from its two variants) of all pairs of
documents in a tidy table.

## Usage

``` r
pairwise_delta(tbl, item, feature, value, method = "burrows", ...)

pairwise_delta_(tbl, item, feature, value, method = "burrows", ...)
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
library(janeaustenr)
library(dplyr)
library(tidytext)

# closest documents in terms of 1000 most frequent words
closest <- austen_books() |>
  unnest_tokens(word, text) |>
  count(book, word) |>
  top_n(1000, n) |>
  pairwise_delta(book, word, n, method = "burrows") |>
  arrange(delta)

closest
#> # A tibble: 30 × 3
#>    item1               item2               delta
#>    <fct>               <fct>               <dbl>
#>  1 Persuasion          Northanger Abbey    0.408
#>  2 Northanger Abbey    Persuasion          0.408
#>  3 Pride & Prejudice   Sense & Sensibility 0.491
#>  4 Sense & Sensibility Pride & Prejudice   0.491
#>  5 Persuasion          Pride & Prejudice   0.769
#>  6 Pride & Prejudice   Persuasion          0.769
#>  7 Northanger Abbey    Pride & Prejudice   0.779
#>  8 Pride & Prejudice   Northanger Abbey    0.779
#>  9 Persuasion          Sense & Sensibility 0.814
#> 10 Sense & Sensibility Persuasion          0.814
#> # ℹ 20 more rows

closest |>
  filter(item1 == "Pride & Prejudice")
#> # A tibble: 5 × 3
#>   item1             item2               delta
#>   <fct>             <fct>               <dbl>
#> 1 Pride & Prejudice Sense & Sensibility 0.491
#> 2 Pride & Prejudice Persuasion          0.769
#> 3 Pride & Prejudice Northanger Abbey    0.779
#> 4 Pride & Prejudice Mansfield Park      1.04 
#> 5 Pride & Prejudice Emma                1.09 

# to remove duplicates, use upper = FALSE
closest <- austen_books() |>
  unnest_tokens(word, text) |>
  count(book, word) |>
  top_n(1000, n) |>
  pairwise_delta(book, word, n, method = "burrows", upper = FALSE) |>
  arrange(delta)

# Can also use Argamon's Linear Delta
closest <- austen_books() |>
  unnest_tokens(word, text) |>
  count(book, word) |>
  top_n(1000, n) |>
  pairwise_delta(book, word, n, method = "argamon", upper = FALSE) |>
  arrange(delta)
```
