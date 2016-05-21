#' A special case of the widely adverb for creating tidy
#' square matrices
#'
#' A special case of \code{\link{widely}}. Used to pre-prepare and
#' post-tidy functions that take an m x n (m items, n features)
#' matrix and return an m x m (item x item) matrix, such as a
#' distance or correlation matrix.
#'
#' @param .f Function to wrap
#' @param item Name of column to use as rows in wide matrix
#' @param feature Name of column to use as columns in wide matrix
#' @param value Name of column to use as values in wide matrix
#' @param diag Whether to include diagonal (i = j) in output
#' @param upper Whether to include upper triangle, which may be
#' duplicated
#' @param ... Extra arguments passed on to \code{widely}
#'
#' @seealso \code{\link{widely}}, \code{\link{pairwise_count}},
#' \code{\link{pairwise_cor}}, \code{\link{pairwise_dist}}
#'
#' @export
squarely <- function(.f, item, feature, value,
                     diag = FALSE, upper = TRUE, ...) {
  squarely_(.f, col_name(substitute(item)),
            col_name(substitute(feature)),
            col_name(substitute(value)),
            diag = diag, upper = upper)
}


#' @rdname squarely
#' @export
squarely_ <- function(.f, item, feature, value,
                      diag = FALSE,
                      upper = TRUE,
                      ...) {
  extra_args <- list(...)

  f <- function(tbl, ...) {
    new_f <- do.call(widely_, c(list(.f, item, feature, value),
                                extra_args))
    ret <- new_f(tbl, ...)

    colnames(ret) <- c("item1", "item2", "value")

    item_vals <- tbl[[item]]

    if (!upper) {
      ret <- ret %>%
        filter(match(item1, item_vals) <= match(item2, item_vals))
    }
    if (!diag) {
      ret <- filter(ret, item1 != item2)
    }

    ret
  }
  f
}
