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
pairwise_dist_ <- function(tbl, group, item, value,
                       method = "euclidean",
                      ...) {
  method <- match.arg(method)

  d_func <- squarely_(function(m) as.matrix(stats::dist(t(m), method = method)),
                      group, item, value, ...)

  tbl %>%
    d_func(method = method) %>%
    rename(distance = value)
}
