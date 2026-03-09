# Cosine similarity of pairs of items

Compute cosine similarity of all pairs of items in a tidy table.

## Usage

``` r
pairwise_similarity(tbl, item, feature, value, ...)

pairwise_similarity_(tbl, item, feature, value, ...)
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

- ...:

  Extra arguments passed on to
  [`squarely()`](https://juliasilge.github.io/widyr/reference/squarely.md),
  such as `diag` and `upper`

## Details

This function uses sparse matrices internally for efficiency, which
means pairs with zero similarity are excluded from the output. To
include zero-similarity pairs, use
[`tidyr::complete()`](https://tidyr.tidyverse.org/reference/complete.html)
on your result: `complete(item1, item2, fill = list(similarity = 0))`.

## See also

[`squarely()`](https://juliasilge.github.io/widyr/reference/squarely.md)

## Examples

``` r
library(janeaustenr)
library(dplyr)
library(tidytext)

# Comparing Jane Austen novels
austen_words <- austen_books() %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words, by = "word") %>%
  count(book, word) %>%
  ungroup()

# closest books to each other
closest <- austen_words %>%
  pairwise_similarity(book, word, n) %>%
  arrange(desc(similarity))

closest
#> # A tibble: 30 × 3
#>    item1               item2               similarity
#>    <fct>               <fct>                    <dbl>
#>  1 Northanger Abbey    Pride & Prejudice        0.509
#>  2 Pride & Prejudice   Northanger Abbey         0.509
#>  3 Emma                Pride & Prejudice        0.493
#>  4 Pride & Prejudice   Emma                     0.493
#>  5 Mansfield Park      Pride & Prejudice        0.483
#>  6 Pride & Prejudice   Mansfield Park           0.483
#>  7 Northanger Abbey    Emma                     0.480
#>  8 Emma                Northanger Abbey         0.480
#>  9 Pride & Prejudice   Sense & Sensibility      0.479
#> 10 Sense & Sensibility Pride & Prejudice        0.479
#> # ℹ 20 more rows

closest %>%
  filter(item1 == "Emma")
#> # A tibble: 5 × 3
#>   item1 item2               similarity
#>   <fct> <fct>                    <dbl>
#> 1 Emma  Pride & Prejudice        0.493
#> 2 Emma  Northanger Abbey         0.480
#> 3 Emma  Mansfield Park           0.473
#> 4 Emma  Sense & Sensibility      0.434
#> 5 Emma  Persuasion               0.410
```
