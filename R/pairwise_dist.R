#' Distances of pairs of items
#'
#' @param tbl Table
#' @param group Group within which to look for correlations
#' @param item Item to compare; will end up in \code{item1} and
#' \code{item2} columns
#' @param value Value
#' @param method Distance measure to be used; see \code{\link{dist}}
#' @param ... Extra arguments passed on to \code{\link{squarely}},
#' such as \code{diag} and \code{upper}
#'
#' @examples
#'
#' library(gapminder)
#' library(dplyr)
#'
#' # closest countries in terms of life expectancy over time
#' closest <- gapminder %>%
#'   pairwise_dist(year, country, lifeExp) %>%
#'   arrange(distance)
#'
#' closest
#'
#' closest %>% filter(item1 == "United States")
#'
#' # to remove duplicates, use upper = FALSE
#' gapminder %>%
#'   pairwise_dist(year, country, lifeExp, upper = FALSE) %>%
#'   arrange(distance)
#'
#' # Can also use Manhattan distance
#' gapminder %>%
#'   pairwise_dist(year, country, lifeExp, method = "manhattan", upper = FALSE) %>%
#'   arrange(distance)
#'
#' @export
pairwise_dist <- function(tbl, group, item, value,
                     method = "euclidean", ...) {
  pairwise_dist_(tbl,
            col_name(substitute(group)),
            col_name(substitute(item)),
            col_name(substitute(value)),
            method = method, ...)
}


#' @rdname pairwise_dist
#' @export
pairwise_dist_ <- function(tbl, group, item, value, method = "euclidean", ...) {
  d_func <- squarely_(function(m) as.matrix(stats::dist(t(m), method = method)),
                      group, item, value, ...)

  tbl %>%
    d_func() %>%
    rename(distance = value)
}
