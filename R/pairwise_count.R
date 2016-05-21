#' Count pairs of items within a group
#'
#' @param tbl Table
#' @param item Item to count pairs of; will end up in \code{item1} and
#' \code{item2} columns
#' @param feature Column within which to count pairs
#' \code{item2} columns
#' @param ... Extra arguments passed on to \code{squarely},
#' such as \code{diag}, \code{upper}, and \code{sort}
#'
#' @export
pairwise_count <- function(tbl, item, feature, ...) {
  pairwise_count_(tbl,
              col_name(substitute(item)),
              col_name(substitute(feature)), ...)
}


#' @rdname pairwise_count
#' @export
pairwise_count_ <- function(tbl, item, feature, ...) {
  func <- squarely_(function(m) m %*% t(m), item, feature,
                    "..value", sparse = TRUE, ...)

  tbl %>%
    distinct_(item, feature) %>%
    mutate(..value = 1) %>%
    func() %>%
    rename(n = value)
}
