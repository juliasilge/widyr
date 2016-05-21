<!-- README.md is generated from README.Rmd. Please edit that file -->



### widyr: Widen, process, and re-tidy a dataset

**License:** [MIT](https://opensource.org/licenses/MIT)

[![Travis-CI Build Status](https://travis-ci.org/dgrtwo/widyr.svg?branch=master)](https://travis-ci.org/dgrtwo/widyr)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/dgrtwo/widyr?branch=master&svg=true)](https://ci.appveyor.com/project/dgrtwo/widyr)
[![Coverage Status](https://img.shields.io/codecov/c/github//master.svg)](https://codecov.io/github/?branch=master)

This package wraps the pattern of un-tidying data into a wide matrix, performing some processing, then turning it back into a tidy form. This is useful for several mathematical operations such as co-occurence counts, correlations, or clustering that are best done on a wide matrix.

### Installation

Install from Github with [devtools](https://github.com/hadley/devtools):


```r
library(devtools)
install_github("dgrtwo/widyr")
```

### Example: gapminder

Consider the gapminder dataset in the [gapminder package](https://cran.r-project.org/web/packages/gapminder/index.html).


```r
library(dplyr)
library(gapminder)

gapminder
#> Source: local data frame [1,704 x 6]
#> 
#>        country continent  year lifeExp      pop gdpPercap
#>         (fctr)    (fctr) (int)   (dbl)    (int)     (dbl)
#> 1  Afghanistan      Asia  1952  28.801  8425333  779.4453
#> 2  Afghanistan      Asia  1957  30.332  9240934  820.8530
#> 3  Afghanistan      Asia  1962  31.997 10267083  853.1007
#> 4  Afghanistan      Asia  1967  34.020 11537966  836.1971
#> 5  Afghanistan      Asia  1972  36.088 13079460  739.9811
#> 6  Afghanistan      Asia  1977  38.438 14880372  786.1134
#> 7  Afghanistan      Asia  1982  39.854 12881816  978.0114
#> 8  Afghanistan      Asia  1987  40.822 13867957  852.3959
#> 9  Afghanistan      Asia  1992  41.674 16317921  649.3414
#> 10 Afghanistan      Asia  1997  41.763 22227415  635.3414
#> ..         ...       ...   ...     ...      ...       ...
```

This tidy format (one-row-per-country-per-year) is very useful for grouping, summarizing, and filtering operations. For example, 


```r
library(ggplot2)

ggplot(gapminder, aes(year, lifeExp, color = continent, group = country)) +
  geom_line()
```

![plot of chunk unnamed-chunk-4](README-unnamed-chunk-4-1.png)

But if we want to *compare* countries (for example, to find countries that are similar to each other), we would have to reshape this dataset.

#### Pairwise operations

The widyr package has pre-wrapped some common functions that operate on such pairs. An example is `pair_dist`:


```r
library(widyr)

gapminder %>%
  pairwise_dist(year, country, lifeExp)
#> Source: local data frame [20,022 x 3]
#> 
#>         item1       item2  distance
#>         (chr)       (chr)     (dbl)
#> 1     Albania Afghanistan 107.41825
#> 2     Algeria Afghanistan  76.75286
#> 3      Angola Afghanistan   4.64934
#> 4   Argentina Afghanistan 109.50686
#> 5   Australia Afghanistan 128.95745
#> 6     Austria Afghanistan 123.51771
#> 7     Bahrain Afghanistan  98.13426
#> 8  Bangladesh Afghanistan  45.33990
#> 9     Belgium Afghanistan 125.41156
#> 10      Benin Afghanistan  39.32262
#> ..        ...         ...       ...
```

In a single step, this finds the Euclidean distance between the `lifeExp` value in each pair of countries by year. We could find the closest pairs of countries overall:


```r
gapminder %>%
  pairwise_dist(year, country, lifeExp) %>%
  arrange(distance)
#> Source: local data frame [20,022 x 3]
#> 
#>             item1          item2 distance
#>             (chr)          (chr)    (dbl)
#> 1         Germany        Belgium 1.075702
#> 2         Belgium        Germany 1.075702
#> 3  United Kingdom    New Zealand 1.509025
#> 4     New Zealand United Kingdom 1.509025
#> 5          Norway    Netherlands 1.557933
#> 6     Netherlands         Norway 1.557933
#> 7           Italy         Israel 1.662690
#> 8          Israel          Italy 1.662690
#> 9         Finland        Austria 1.936558
#> 10        Austria        Finland 1.936558
#> ..            ...            ...      ...
```

Notice that this includes duplicates (Germany/Belgium . To avoid those (the upper triangle of the distance matrix), use `upper = FALSE`:


```r
gapminder %>%
  pairwise_dist(year, country, lifeExp, upper = FALSE) %>%
  arrange(distance)
#> Source: local data frame [10,011 x 3]
#> 
#>          item1          item2 distance
#>          (chr)          (chr)    (dbl)
#> 1      Belgium        Germany 1.075702
#> 2  New Zealand United Kingdom 1.509025
#> 3  Netherlands         Norway 1.557933
#> 4       Israel          Italy 1.662690
#> 5      Austria        Finland 1.936558
#> 6      Belgium United Kingdom 1.949243
#> 7      Iceland         Sweden 2.005176
#> 8      Comoros     Mauritania 2.008199
#> 9      Belgium  United States 2.092081
#> 10     Germany        Ireland 2.097239
#> ..         ...            ...      ...
```

In some analyses, we may be interested in correlation rather than distance of pairs. For this we would use `pairwise_cor`:


```r
gapminder %>%
  pairwise_cor(year, country, lifeExp, upper = FALSE) %>%
  arrange(desc(correlation))
#> Source: local data frame [10,011 x 3]
#> 
#>           item1                 item2 correlation
#>           (chr)                 (chr)       (dbl)
#> 1     Indonesia            Mauritania   0.9996291
#> 2       Morocco               Senegal   0.9995515
#> 3  Saudi Arabia    West Bank and Gaza   0.9995156
#> 4        Brazil                France   0.9994246
#> 5       Bahrain               Reunion   0.9993649
#> 6      Malaysia Sao Tome and Principe   0.9993233
#> 7          Peru                 Syria   0.9993063
#> 8       Bolivia                Gambia   0.9992930
#> 9     Indonesia               Morocco   0.9992799
#> 10        Libya               Senegal   0.9992710
#> ..          ...                   ...         ...
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
