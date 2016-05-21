#' Adverb for functions that operate on matrices in "wide"
#' format
#'
#' Modify a function in order to pre-cast the input into a wide
#' matrix format, perform the function, and then
#' re-tidy the output.
#'
#' @param .f Function being wrapped
#' @param row Name of column to use as rows in wide matrix
#' @param column Name of column to use as columns in wide matrix
#' @param value Name of column to use as values in wide matrix
#' @param sort Whether to sort in descending order of \code{value}
#' @param maximum_size To prevent crashing, a maximum size of a
#' non-sparse matrix to be created. Set to NULL to allow any size
#' matrix.
#' @param sparse Whether to use a sparse matrix
#'
#' @import dplyr
#' @import Matrix
#' @importFrom broom tidy
#'
#' @examples
#'
#' library(dplyr)
#' library(gapminder)
#'
#' gapminder
#'
#' gapminder %>%
#'   widely(cor, year, country, lifeExp)()
#'
#'
#' @export
widely <- function(.f, row, column, value,
                   sort = FALSE,
                   sparse = FALSE,
                   maximum_size = 1e7) {
  widely_(.f,
          col_name(substitute(row)),
          col_name(substitute(column)),
          col_name(substitute(value)),
          sort = sort,
          sparse = sparse,
          maximum_size = maximum_size)
}


#' @rdname widely
#' @export
widely_ <- function(.f, row, column, value,
                    sort = FALSE,
                    sparse = FALSE,
                    maximum_size = 1e7) {
  f <- function(tbl, ...) {
    if (!sparse) {
      if (!is.null(maximum_size)) {
        matrix_size <- (length(unique(tbl[[row]])) *
                        length(unique(tbl[[column]])))
        if (matrix_size > maximum_size) {
          stop("Size of acast matrix, ", matrix_size,
               " will be too large. Set maximum_size = NULL to avoid ",
               "this error (make sure your memory is sufficient), ",
               "or consider using sparse = TRUE.")
        }
      }

      form <- stats::as.formula(paste(row, column, sep = " ~ "))

      input <- reshape2::acast(tbl, form, value.var = value, fill = 0)
    } else {
      input <- tidytext::cast_sparse_(tbl, row, column, value)
    }
    output <- .f(input, ...)

    ret <- output %>%
      custom_melt() %>%
      tbl_df()

    if (sort) {
      ret <- arrange(ret, desc(value))
    }
    ret
  }
  f
}


#' Tidy a function output based on some guesses
#' @noRd
custom_melt <- function(m) {
  if (inherits(m, "data.frame")) {
    stop("Output is a data frame: don't know how to fix")
  }
  if (inherits(m, "matrix")) {
    ret <- reshape2::melt(m, varnames = c("item1", "item2"), as.is = TRUE)
    return(ret)
  }
  # default to broom/tidytext's tidy
  ret <- purrr::possibly(broom::tidy, NULL)(m)
  if (is.null(ret)) {
    ret <- tidytext::tidy(m)
  }
  colnames(ret) <- c("item1", "item2", "value")
  ret
}
