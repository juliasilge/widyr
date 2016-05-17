#' A special case of the widely adverb for creating tidy
#' square matrices
#'
#' A special case of \code{\link{widely}}. Used to pre-prepare and
#' post-tidy functions that return a square matrix, such as a
#' distance or correlation matrix.
#'
#' @param .f Function to wrap
#' @param row Name of column to use as rows in wide matrix
#' @param column Name of column to use as columns in wide matrix
#' @param value Name of column to use as values in wide matrix
#' @param diag Whether to include diagonal (i = j) in output
#' @param upper Whether to include upper triangle, which may be
#' duplicated
#' @param ... Extra arguments passed on to widely
#'
#' @seealso \code{\link{widely}}, \code{\link{pairwise_count}},
#' \code{\link{pairwise_cor}}
#'
#' @export
squarely <- function(.f, row, column, value,
                     diag = FALSE,
                     upper = TRUE,
                     ...) {
  squarely_(.f, col_name(substitute(row)),
            col_name(substitute(column)),
            col_name(substitute(value)),
            diag = diag, upper = upper)
}


#' @rdname squarely
#' @export
squarely_ <- function(.f, row, column, value,
                      diag = FALSE,
                      upper = TRUE,
                      ...) {
  extra_args <- list(...)

  f <- function(tbl, ...) {
    new_f <- do.call(widely_, c(list(.f, row, column, value),
                                extra_args))
    ret <- new_f(tbl, ...)

    col_vals <- tbl[[column]]

    if (!upper) {
      ret <- ret %>%
        filter(match(item1, col_vals) <= match(item2, col_vals))
    }
    if (!diag) {
      ret <- filter(ret, item1 != item2)
    }

    ret
  }
  f
}
