<!-- README.md is generated from README.Rmd. Please edit that file -->



# widyr: Widen, process, and re-tidy a dataset

**License:** [MIT](https://opensource.org/licenses/MIT)

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/widyr)](https://cran.r-project.org/package=widyr)
[![Travis-CI Build Status](https://travis-ci.org/dgrtwo/widyr.svg?branch=master)](https://travis-ci.org/dgrtwo/widyr)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/dgrtwo/widyr?branch=master&svg=true)](https://ci.appveyor.com/project/dgrtwo/widyr)
[![Coverage Status](https://img.shields.io/codecov/c/github/dgrtwo/widyr/master.svg)](https://codecov.io/github/dgrtwo/widyr?branch=master)

This package wraps the pattern of un-tidying data into a wide matrix, performing some processing, then turning it back into a tidy form. This is useful for several mathematical operations such as co-occurrence counts, correlations, or clustering that are best done on a wide matrix.

## Installation

Install from CRAN with:


```r
install.packages("widyr")
```

Or install the development version from Github with [devtools](https://github.com/hadley/devtools):


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
library(gapminder)

gapminder
#> # A tibble: 1,704 x 6
#>    country     continent  year lifeExp      pop gdpPercap
#>    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
#>  1 Afghanistan Asia       1952    28.8  8425333      779.
#>  2 Afghanistan Asia       1957    30.3  9240934      821.
#>  3 Afghanistan Asia       1962    32.0 10267083      853.
#>  4 Afghanistan Asia       1967    34.0 11537966      836.
#>  5 Afghanistan Asia       1972    36.1 13079460      740.
#>  6 Afghanistan Asia       1977    38.4 14880372      786.
#>  7 Afghanistan Asia       1982    39.9 12881816      978.
#>  8 Afghanistan Asia       1987    40.8 13867957      852.
#>  9 Afghanistan Asia       1992    41.7 16317921      649.
#> 10 Afghanistan Asia       1997    41.8 22227415      635.
#> # … with 1,694 more rows
```

This tidy format (one-row-per-country-per-year) is very useful for grouping, summarizing, and filtering operations. But if we want to *compare* countries (for example, to find countries that are similar to each other), we would have to reshape this dataset. Note that here, each country is an **item**, while each year is the **feature**.

#### Pairwise operations

The widyr package offers `pairwise_` functions that operate on pairs of items within data. An example is `pairwise_dist`:


```r
library(widyr)

gapminder %>%
  pairwise_dist(country, year, lifeExp)
#> # A tibble: 20,022 x 3
#>    item1      item2       distance
#>    <fct>      <fct>          <dbl>
#>  1 Albania    Afghanistan   107.  
#>  2 Algeria    Afghanistan    76.8 
#>  3 Angola     Afghanistan     4.65
#>  4 Argentina  Afghanistan   110.  
#>  5 Australia  Afghanistan   129.  
#>  6 Austria    Afghanistan   124.  
#>  7 Bahrain    Afghanistan    98.1 
#>  8 Bangladesh Afghanistan    45.3 
#>  9 Belgium    Afghanistan   125.  
#> 10 Benin      Afghanistan    39.3 
#> # … with 20,012 more rows
```

This finds the Euclidean distance between the `lifeExp` value in each pair of countries. It knows which values to compare between countries with `year`, which is the feature column.

We could find the closest pairs of countries overall with `arrange()`:


```r
gapminder %>%
  pairwise_dist(country, year, lifeExp) %>%
  arrange(distance)
#> # A tibble: 20,022 x 3
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
#> # … with 20,012 more rows
```

Notice that this includes duplicates (Germany/Belgium and Belgium/Germany). To avoid those (the upper triangle of the distance matrix), use `upper = FALSE`:


```r
gapminder %>%
  pairwise_dist(country, year, lifeExp, upper = FALSE) %>%
  arrange(distance)
#> # A tibble: 10,011 x 3
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
#> # … with 10,001 more rows
```

In some analyses, we may be interested in correlation rather than distance of pairs. For this we would use `pairwise_cor`:


```r
gapminder %>%
  pairwise_cor(country, year, lifeExp, upper = FALSE)
#> # A tibble: 10,011 x 3
#>    item1       item2     correlation
#>    <fct>       <fct>           <dbl>
#>  1 Afghanistan Albania         0.966
#>  2 Afghanistan Algeria         0.987
#>  3 Albania     Algeria         0.953
#>  4 Afghanistan Angola          0.986
#>  5 Albania     Angola          0.976
#>  6 Algeria     Angola          0.952
#>  7 Afghanistan Argentina       0.971
#>  8 Albania     Argentina       0.949
#>  9 Algeria     Argentina       0.991
#> 10 Angola      Argentina       0.936
#> # … with 10,001 more rows
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/dgrtwo/widyr/blob/master/CONDUCT.md). By participating in this project you agree to abide by its terms.
