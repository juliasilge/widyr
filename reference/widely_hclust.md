# Cluster pairs of items into groups using hierarchical clustering

Reshape a table that represents pairwise distances into hierarchical
clusters, returning a table with `item` and `cluster` columns.

## Usage

``` r
widely_hclust(tbl, item1, item2, distance, k = NULL, h = NULL)
```

## Arguments

- tbl:

  Table

- item1:

  First item

- item2:

  Second item

- distance:

  Distance column

- k:

  The desired number of groups

- h:

  Height at which to cut the hierarchically clustered tree

## See also

[cutree](https://rdrr.io/r/stats/cutree.html)

## Examples

``` r
library(gapminder)
library(dplyr)

# Construct Euclidean distances between countries based on life
# expectancy over time
country_distances <- gapminder %>%
  pairwise_dist(country, year, lifeExp)

country_distances
#> # A tibble: 20,022 × 3
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
#> # ℹ 20,012 more rows

# Turn this into 5 hierarchical clusters
clusters <- country_distances %>%
  widely_hclust(item1, item2, distance, k = 8)

# Examine a few such clusters
clusters %>% filter(cluster == 1)
#> # A tibble: 27 × 2
#>    item                   cluster
#>    <chr>                  <fct>  
#>  1 Albania                1      
#>  2 Argentina              1      
#>  3 Bosnia and Herzegovina 1      
#>  4 Bulgaria               1      
#>  5 Costa Rica             1      
#>  6 Croatia                1      
#>  7 Cuba                   1      
#>  8 Czech Republic         1      
#>  9 Hungary                1      
#> 10 Jamaica                1      
#> # ℹ 17 more rows
clusters %>% filter(cluster == 2)
#> # A tibble: 26 × 2
#>    item        cluster
#>    <chr>       <fct>  
#>  1 Algeria     2      
#>  2 China       2      
#>  3 Egypt       2      
#>  4 El Salvador 2      
#>  5 Guatemala   2      
#>  6 Honduras    2      
#>  7 India       2      
#>  8 Indonesia   2      
#>  9 Iran        2      
#> 10 Iraq        2      
#> # ℹ 16 more rows
```
