# widyr: Widen, process, and re-tidy a dataset

This package wraps the pattern of un-tidying data into a wide matrix,
performing some processing, then turning it back into a tidy form. This
is useful for several mathematical operations such as co-occurrence
counts, correlations, or clustering that are best done on a wide matrix.

## Towards a precise definition of “wide” data

The term “wide data” has gone out of fashion as being “imprecise”
[(Wickham 2014)](http://vita.had.co.nz/papers/tidy-data.pdf)), but I
think with a proper definition the term could be entirely meaningful and
useful.

A **wide** dataset is one or more matrices where:

- Each row is one **item**
- Each column is one **feature**
- Each value is one **observation**
- Each matrix is one **variable**

When would you want data to be wide rather than tidy? Notable examples
include classification, clustering, correlation, factorization, or other
operations that can take advantage of a matrix structure. In general,
when you want to **compare between items** rather than compare between
variables, this is a useful structure.

The widyr package is based on the observation that during a tidy data
analysis, you often want data to be wide only *temporarily*, before
returning to a tidy structure for visualization and further analysis.
widyr makes this easy through a set of `pairwise_` functions.

## Example: gapminder

Consider the gapminder dataset in the [gapminder
package](https://CRAN.R-project.org/package=gapminder).

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(gapminder)

gapminder
```

    ## # A tibble: 1,704 × 6
    ##    country     continent  year lifeExp      pop gdpPercap
    ##    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
    ##  1 Afghanistan Asia       1952    28.8  8425333      779.
    ##  2 Afghanistan Asia       1957    30.3  9240934      821.
    ##  3 Afghanistan Asia       1962    32.0 10267083      853.
    ##  4 Afghanistan Asia       1967    34.0 11537966      836.
    ##  5 Afghanistan Asia       1972    36.1 13079460      740.
    ##  6 Afghanistan Asia       1977    38.4 14880372      786.
    ##  7 Afghanistan Asia       1982    39.9 12881816      978.
    ##  8 Afghanistan Asia       1987    40.8 13867957      852.
    ##  9 Afghanistan Asia       1992    41.7 16317921      649.
    ## 10 Afghanistan Asia       1997    41.8 22227415      635.
    ## # ℹ 1,694 more rows

This tidy format (one-row-per-country-per-year) is very useful for
grouping, summarizing, and filtering operations. But if we want to
*compare pairs of countries* (for example, to find countries that are
similar to each other), we would have to reshape this dataset. Note that
here, country is the **item**, while year is the **feature** column.

#### Pairwise operations

The widyr package offers `pairwise_` functions that operate on pairs of
items within data. An example is `pairwise_dist`:

``` r
library(widyr)

gapminder %>%
  pairwise_dist(country, year, lifeExp)
```

    ## # A tibble: 20,022 × 3
    ##    item1      item2       distance
    ##    <fct>      <fct>          <dbl>
    ##  1 Albania    Afghanistan   107.  
    ##  2 Algeria    Afghanistan    76.8 
    ##  3 Angola     Afghanistan     4.65
    ##  4 Argentina  Afghanistan   110.  
    ##  5 Australia  Afghanistan   129.  
    ##  6 Austria    Afghanistan   124.  
    ##  7 Bahrain    Afghanistan    98.1 
    ##  8 Bangladesh Afghanistan    45.3 
    ##  9 Belgium    Afghanistan   125.  
    ## 10 Benin      Afghanistan    39.3 
    ## # ℹ 20,012 more rows

In a single step, this finds the Euclidean distance between the
`lifeExp` value in each pair of countries, matching pairs based on year.
We could find the closest pairs of countries overall with
[`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html):

``` r
gapminder %>%
  pairwise_dist(country, year, lifeExp) %>%
  arrange(distance)
```

    ## # A tibble: 20,022 × 3
    ##    item1          item2          distance
    ##    <fct>          <fct>             <dbl>
    ##  1 Germany        Belgium            1.08
    ##  2 Belgium        Germany            1.08
    ##  3 United Kingdom New Zealand        1.51
    ##  4 New Zealand    United Kingdom     1.51
    ##  5 Norway         Netherlands        1.56
    ##  6 Netherlands    Norway             1.56
    ##  7 Italy          Israel             1.66
    ##  8 Israel         Italy              1.66
    ##  9 Finland        Austria            1.94
    ## 10 Austria        Finland            1.94
    ## # ℹ 20,012 more rows

Notice that this includes duplicates (Germany/Belgium and
Belgium/Germany). To avoid those (the upper triangle of the distance
matrix), use `upper = FALSE`:

``` r
gapminder %>%
  pairwise_dist(country, year, lifeExp, upper = FALSE) %>%
  arrange(distance)
```

    ## # A tibble: 10,011 × 3
    ##    item1       item2          distance
    ##    <fct>       <fct>             <dbl>
    ##  1 Belgium     Germany            1.08
    ##  2 New Zealand United Kingdom     1.51
    ##  3 Netherlands Norway             1.56
    ##  4 Israel      Italy              1.66
    ##  5 Austria     Finland            1.94
    ##  6 Belgium     United Kingdom     1.95
    ##  7 Iceland     Sweden             2.01
    ##  8 Comoros     Mauritania         2.01
    ##  9 Belgium     United States      2.09
    ## 10 Germany     Ireland            2.10
    ## # ℹ 10,001 more rows

In some analyses, we may be interested in correlation rather than
distance of pairs. For this we would use `pairwise_cor`:

``` r
gapminder %>%
  pairwise_cor(country, year, lifeExp, upper = FALSE, sort = TRUE)
```

    ## # A tibble: 10,011 × 3
    ##    item1        item2                 correlation
    ##    <fct>        <fct>                       <dbl>
    ##  1 Indonesia    Mauritania                  1.000
    ##  2 Morocco      Senegal                     1.000
    ##  3 Saudi Arabia West Bank and Gaza          1.000
    ##  4 Brazil       France                      0.999
    ##  5 Bahrain      Reunion                     0.999
    ##  6 Malaysia     Sao Tome and Principe       0.999
    ##  7 Peru         Syria                       0.999
    ##  8 Bolivia      Gambia                      0.999
    ##  9 Indonesia    Morocco                     0.999
    ## 10 Libya        Senegal                     0.999
    ## # ℹ 10,001 more rows
