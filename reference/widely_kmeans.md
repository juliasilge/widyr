# Cluster items based on k-means across features

Given a tidy table of features describing each item, perform k-means
clustering using [`kmeans()`](https://rdrr.io/r/stats/kmeans.html) and
retidy the data into one-row-per-cluster.

## Usage

``` r
widely_kmeans(tbl, item, feature, value, k, fill = 0, ...)
```

## Arguments

- tbl:

  Table

- item:

  Item to cluster (as a bare column name)

- feature:

  Feature column (dimension in clustering)

- value:

  Value column

- k:

  Number of clusters

- fill:

  What to fill in for missing values

- ...:

  Other arguments passed on to
  [`kmeans()`](https://rdrr.io/r/stats/kmeans.html)

## See also

[`widely_hclust()`](https://juliasilge.github.io/widyr/reference/widely_hclust.md)

## Examples

``` r
library(gapminder)
library(dplyr)

clusters <- gapminder %>%
  widely_kmeans(country, year, lifeExp, k = 5)

clusters
#> # A tibble: 142 × 2
#>    country        cluster
#>    <fct>          <fct>  
#>  1 Australia      1      
#>  2 Austria        1      
#>  3 Belgium        1      
#>  4 Canada         1      
#>  5 Czech Republic 1      
#>  6 Denmark        1      
#>  7 Finland        1      
#>  8 France         1      
#>  9 Germany        1      
#> 10 Greece         1      
#> # ℹ 132 more rows

clusters %>%
  count(cluster)
#> # A tibble: 5 × 2
#>   cluster     n
#>   <fct>   <int>
#> 1 1          29
#> 2 2          27
#> 3 3          31
#> 4 4          24
#> 5 5          31

# Examine a few clusters
clusters %>% filter(cluster == 1)
#> # A tibble: 29 × 2
#>    country        cluster
#>    <fct>          <fct>  
#>  1 Australia      1      
#>  2 Austria        1      
#>  3 Belgium        1      
#>  4 Canada         1      
#>  5 Czech Republic 1      
#>  6 Denmark        1      
#>  7 Finland        1      
#>  8 France         1      
#>  9 Germany        1      
#> 10 Greece         1      
#> # ℹ 19 more rows
clusters %>% filter(cluster == 2)
#> # A tibble: 27 × 2
#>    country            cluster
#>    <fct>              <fct>  
#>  1 Algeria            2      
#>  2 Brazil             2      
#>  3 China              2      
#>  4 Dominican Republic 2      
#>  5 Ecuador            2      
#>  6 Egypt              2      
#>  7 El Salvador        2      
#>  8 Guatemala          2      
#>  9 Honduras           2      
#> 10 Indonesia          2      
#> # ℹ 17 more rows
```
