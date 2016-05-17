#' Count pairs of items within a group
#'
#' @param tbl Table
#' @param group Column within which to count pairs
#' @param item Item to compare; will end up in \code{item1} and
#' \code{item2} columns
#' @param ... Extra arguments passed on to \code{squarely},
#' such as \code{diag}, \code{upper}, and \code{sort}
#'
#' @export
pairwise_count <- function(tbl, group, item, ...) {
  pairwise_count_(tbl,
              col_name(substitute(group)),
              col_name(substitute(item)), ...)
}


#' @rdname pairwise_count
#' @export
pairwise_count_ <- function(tbl, group, item, ...) {
  func <- squarely_(function(m) t(m) %*% m, group, item,
                    "..value", sparse = TRUE, ...)

  tbl %>%
    distinct_(group, item) %>%
    mutate(..value = 1) %>%
    func() %>%
    rename(n = value)
}
