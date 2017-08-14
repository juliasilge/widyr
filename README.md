<!-- README.md is generated from README.Rmd. Please edit that file -->



# widyr: Widen, process, and re-tidy a dataset

**License:** [MIT](https://opensource.org/licenses/MIT)

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/widyr)](https://cran.r-project.org/package=widyr)
[![Travis-CI Build Status](https://travis-ci.org/dgrtwo/widyr.svg?branch=master)](https://travis-ci.org/dgrtwo/widyr)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/dgrtwo/widyr?branch=master&svg=true)](https://ci.appveyor.com/project/dgrtwo/widyr)
[![Coverage Status](https://img.shields.io/codecov/c/github/dgrtwo/widyr/master.svg)](https://codecov.io/github/dgrtwo/widyr?branch=master)

This package wraps the pattern of un-tidying data into a wide matrix, performing some processing, then turning it back into a tidy form. This is useful for several mathematical operations such as co-occurence counts, correlations, or clustering that are best done on a wide matrix.

### Installation

Install from Github with [devtools](https://github.com/hadley/devtools):


```r
library(devtools)
install_github("dgrtwo/widyr")
```

## Towards a precise definition of "wide" data

The term "wide data" has gone out of fashion as being "imprecise" [(Wickham 2014)](http://vita.had.co.nz/papers/tidy-data.pdf), but I think with a proper definition the term could be entirely meaningful and useful.

A **wide** dataset is one or more matrices where:

* Each row is one **item**
* Each column is one **feature**
* Each value is one **observation**
* Each matrix is one **variable**

When would you want data to be wide rather than tidy? Notable examples include classification, clustering, correlation, factorization, or other operations that can take advantage of a matrix structure. In general, when you want to **compare between pairs of items** rather than compare between variables or between groups of observations, this is a useful structure.

The widyr package is based on the observation that during a tidy data analysis, you often want data to be wide only *temporarily*, before returning to a tidy structure for visualization and further analysis. widyr makes this easy through a set of `pairwise_` functions.

## Example: gapminder

Consider the gapminder dataset in the [gapminder package](https://CRAN.R-project.org/package=gapminder).


```r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(gapminder)

gapminder
#> # A tibble: 1,704 x 6
#>        country continent  year lifeExp      pop gdpPercap
#>         <fctr>    <fctr> <int>   <dbl>    <int>     <dbl>
#>  1 Afghanistan      Asia  1952  28.801  8425333  779.4453
#>  2 Afghanistan      Asia  1957  30.332  9240934  820.8530
#>  3 Afghanistan      Asia  1962  31.997 10267083  853.1007
#>  4 Afghanistan      Asia  1967  34.020 11537966  836.1971
#>  5 Afghanistan      Asia  1972  36.088 13079460  739.9811
#>  6 Afghanistan      Asia  1977  38.438 14880372  786.1134
#>  7 Afghanistan      Asia  1982  39.854 12881816  978.0114
#>  8 Afghanistan      Asia  1987  40.822 13867957  852.3959
#>  9 Afghanistan      Asia  1992  41.674 16317921  649.3414
#> 10 Afghanistan      Asia  1997  41.763 22227415  635.3414
#> # ... with 1,694 more rows
```

This tidy format (one-row-per-country-per-year) is very useful for grouping, summarizing, and filtering operations. But if we want to *compare* countries (for example, to find countries that are similar to each other), we would have to reshape this dataset. Note that here, each country is an **item**, while each year is the **feature**.

#### Pairwise operations

The widyr package offers `pairwise_` functions that operate on pairs of items within data. An example is `pairwise_dist`:


```r
library(widyr)

gapminder %>%
  pairwise_dist(country, year, lifeExp)
#> # A tibble: 20,022 x 3
#>         item1       item2  distance
#>        <fctr>      <fctr>     <dbl>
#>  1    Albania Afghanistan 107.41825
#>  2    Algeria Afghanistan  76.75286
#>  3     Angola Afghanistan   4.64934
#>  4  Argentina Afghanistan 109.50686
#>  5  Australia Afghanistan 128.95745
#>  6    Austria Afghanistan 123.51771
#>  7    Bahrain Afghanistan  98.13426
#>  8 Bangladesh Afghanistan  45.33990
#>  9    Belgium Afghanistan 125.41156
#> 10      Benin Afghanistan  39.32262
#> # ... with 20,012 more rows
```

This finds the Euclidean distance between the `lifeExp` value in each pair of countries. It knows which values to compare between countries with `year`, which is the feature column.

We could find the closest pairs of countries overall with `arrange()`:


```r
gapminder %>%
  pairwise_dist(country, year, lifeExp) %>%
  arrange(distance)
#> # A tibble: 20,022 x 3
#>             item1          item2 distance
#>            <fctr>         <fctr>    <dbl>
#>  1        Germany        Belgium 1.075702
#>  2        Belgium        Germany 1.075702
#>  3 United Kingdom    New Zealand 1.509025
#>  4    New Zealand United Kingdom 1.509025
#>  5         Norway    Netherlands 1.557933
#>  6    Netherlands         Norway 1.557933
#>  7          Italy         Israel 1.662690
#>  8         Israel          Italy 1.662690
#>  9        Finland        Austria 1.936558
#> 10        Austria        Finland 1.936558
#> # ... with 20,012 more rows
```

Notice that this includes duplicates (Germany/Belgium and Belgium/Germany). To avoid those (the upper triangle of the distance matrix), use `upper = FALSE`:


```r
gapminder %>%
  pairwise_dist(country, year, lifeExp, upper = FALSE) %>%
  arrange(distance)
#> # A tibble: 10,011 x 3
#>          item1          item2 distance
#>         <fctr>         <fctr>    <dbl>
#>  1     Belgium        Germany 1.075702
#>  2 New Zealand United Kingdom 1.509025
#>  3 Netherlands         Norway 1.557933
#>  4      Israel          Italy 1.662690
#>  5     Austria        Finland 1.936558
#>  6     Belgium United Kingdom 1.949243
#>  7     Iceland         Sweden 2.005176
#>  8     Comoros     Mauritania 2.008199
#>  9     Belgium  United States 2.092081
#> 10     Germany        Ireland 2.097239
#> # ... with 10,001 more rows
```

In some analyses, we may be interested in correlation rather than distance of pairs. For this we would use `pairwise_cor`:


```r
gapminder %>%
  pairwise_cor(country, year, lifeExp, upper = FALSE)
#> # A tibble: 10,011 x 3
#>          item1     item2 correlation
#>         <fctr>    <fctr>       <dbl>
#>  1 Afghanistan   Albania   0.9656953
#>  2 Afghanistan   Algeria   0.9868220
#>  3     Albania   Algeria   0.9532937
#>  4 Afghanistan    Angola   0.9855294
#>  5     Albania    Angola   0.9760571
#>  6     Algeria    Angola   0.9521563
#>  7 Afghanistan Argentina   0.9705203
#>  8     Albania Argentina   0.9488283
#>  9     Algeria Argentina   0.9909654
#> 10      Angola Argentina   0.9363440
#> # ... with 10,001 more rows
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
