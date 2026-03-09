# Adverb for functions that operate on matrices in "wide" format

Modify a function in order to pre-cast the input into a wide matrix
format, perform the function, and then re-tidy (e.g. melt) the output
into a tidy table.

## Usage

``` r
widely(.f, sort = FALSE, sparse = FALSE, maximum_size = 1e+07)

widely_(.f, sort = FALSE, sparse = FALSE, maximum_size = 1e+07)
```

## Arguments

- .f:

  Function being wrapped

- sort:

  Whether to sort in descending order of `value`

- sparse:

  Whether to cast to a sparse matrix

- maximum_size:

  To prevent crashing, a maximum size of a non-sparse matrix to be
  created. Set to NULL to allow any size matrix.

## Value

Returns a function that takes at least four arguments:

- tbl:

  A table

- row:

  Name of column to use as rows in wide matrix

- column:

  Name of column to use as columns in wide matrix

- value:

  Name of column to use as values in wide matrix

- ...:

  Arguments passed on to inner function

`widely` creates a function that takes those columns as bare names,
`widely_` a function that takes them as strings.

## Examples

``` r
library(dplyr)
library(gapminder)

gapminder
#> # A tibble: 1,704 × 6
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
#> # ℹ 1,694 more rows

gapminder %>%
  widely(dist)(country, year, lifeExp)
#> # A tibble: 10,011 × 3
#>    item1       item2       value
#>    <fct>       <fct>       <dbl>
#>  1 Afghanistan Albania    107.  
#>  2 Afghanistan Algeria     76.8 
#>  3 Afghanistan Angola       4.65
#>  4 Afghanistan Argentina  110.  
#>  5 Afghanistan Australia  129.  
#>  6 Afghanistan Austria    124.  
#>  7 Afghanistan Bahrain     98.1 
#>  8 Afghanistan Bangladesh  45.3 
#>  9 Afghanistan Belgium    125.  
#> 10 Afghanistan Benin       39.3 
#> # ℹ 10,001 more rows

# can perform within groups
closest_continent <- gapminder %>%
  group_by(continent) %>%
  widely(dist)(country, year, lifeExp)
closest_continent
#> # A tibble: 2,590 × 4
#> # Groups:   continent [5]
#>    continent item1       item2            value
#>    <fct>     <fct>       <fct>            <dbl>
#>  1 Asia      Afghanistan Bahrain           98.1
#>  2 Asia      Afghanistan Bangladesh        45.3
#>  3 Asia      Afghanistan Cambodia          41.8
#>  4 Asia      Afghanistan China             86.2
#>  5 Asia      Afghanistan Hong Kong, China 125. 
#>  6 Asia      Afghanistan India             56.1
#>  7 Asia      Afghanistan Indonesia         62.3
#>  8 Asia      Afghanistan Iran              74.5
#>  9 Asia      Afghanistan Iraq              66.9
#> 10 Asia      Afghanistan Israel           125. 
#> # ℹ 2,580 more rows

# for example, find the closest pair in each
closest_continent %>%
  top_n(1, -value)
#> # A tibble: 5 × 4
#> # Groups:   continent [5]
#>   continent item1     item2              value
#>   <fct>     <fct>     <fct>              <dbl>
#> 1 Asia      Jordan    West Bank and Gaza  2.94
#> 2 Europe    Belgium   Germany             1.08
#> 3 Africa    Comoros   Mauritania          2.01
#> 4 Americas  Honduras  Peru                3.95
#> 5 Oceania   Australia New Zealand         3.55
```
