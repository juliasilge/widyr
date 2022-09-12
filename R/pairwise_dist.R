#' Distances of pairs of items
#'
#' Compute distances of all pairs of items in a tidy table.
#'
#' @param tbl Table
#' @param item Item to compare; will end up in `item1` and
#' `item2` columns
#' @param feature Column describing the feature that links one item to others
#' @param value Value
#' @param method Distance measure to be used; see [dist()]
#' @param ... Extra arguments passed on to [squarely()],
#' such as `diag` and `upper`
#'
#' @seealso [squarely()]
#'
#' @examples
#'
#' library(gapminder)
#' library(dplyr)
#'
#' # closest countries in terms of life expectancy over time
#' closest <- gapminder %>%
#'   pairwise_dist(country, year, lifeExp) %>%
#'   arrange(distance)
#'
#' closest
#'
#' closest %>%
#'   filter(item1 == "United States")
#'
#' # to remove duplicates, use upper = FALSE
#' gapminder %>%
#'   pairwise_dist(country, year, lifeExp, upper = FALSE) %>%
#'   arrange(distance)
#'
#' # Can also use Manhattan distance
#' gapminder %>%
#'   pairwise_dist(country, year, lifeExp, method = "manhattan", upper = FALSE) %>%
#'   arrange(distance)
#'
#' @export
pairwise_dist <- function(tbl, item, feature, value,
                     method = "euclidean", ...) {
  pairwise_dist_(tbl,
            col_name(substitute(item)),
            col_name(substitute(feature)),
            col_name(substitute(value)),
            method = method, ...)
}


#' @rdname pairwise_dist
#' @export
pairwise_dist_ <- function(tbl, item, feature, value, method = "euclidean", ...) {
  d_func <- squarely_(function(m) as.matrix(stats::dist(m, method = method)), ...)

  tbl %>%
    d_func(item, feature, value) %>%
    rename(distance = value)
}
