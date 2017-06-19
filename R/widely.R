#' Adverb for functions that operate on matrices in "wide"
#' format
#'
#' Modify a function in order to pre-cast the input into a wide
#' matrix format, perform the function, and then
#' re-tidy (e.g. melt) the output into a tidy table.
#'
#' @param .f Function being wrapped
#' @param sort Whether to sort in descending order of \code{value}
#' @param maximum_size To prevent crashing, a maximum size of a
#' non-sparse matrix to be created. Set to NULL to allow any size
#' matrix.
#' @param sparse Whether to cast to a sparse matrix
#'
#' @return Returns a function that takes at least four arguments:
#'   \item{tbl}{A table}
#'   \item{row}{Name of column to use as rows in wide matrix}
#'   \item{column}{Name of column to use as columns in wide matrix}
#'   \item{value}{Name of column to use as values in wide matrix}
#'   \item{...}{Arguments passed on to inner function}
#'
#' \code{widely} creates a function that takes those columns as
#' bare names, \code{widely_} a function that takes them as strings.
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
#'   widely(dist)(country, year, lifeExp)
#'
#' # can perform within groups
#' closest_continent <- gapminder %>%
#'   group_by(continent) %>%
#'   widely(dist)(country, year, lifeExp)
#' closest_continent
#'
#' # for example, find the closest pair in each
#' closest_continent %>%
#'   top_n(1, -value)
#'
#' @export
widely <- function(.f,
                   sort = FALSE,
                   sparse = FALSE,
                   maximum_size = 1e7) {
  function(tbl, row, column, value, ...) {
    inner_func <- widely_(.f,
                          sort = sort,
                          sparse = sparse,
                          maximum_size = maximum_size)

    inner_func(tbl,
               col_name(substitute(row)),
               col_name(substitute(column)),
               col_name(substitute(value)),
               ...)
  }
}


#' @rdname widely
#' @export
widely_ <- function(.f,
                    sort = FALSE,
                    sparse = FALSE,
                    maximum_size = 1e7) {
  f <- function(tbl, row, column, value, ...) {
    if (inherits(tbl, "grouped_df")) {
      # perform within each group, then restore groups
      ret <- tbl %>%
        tidyr::nest_("..data", nest_cols = c(row, column, value)) %>%
        mutate(..data = purrr::map(..data, f, row, column, value)) %>%
        tidyr::unnest_("..data") %>%
        group_by_(.dots = dplyr::groups(tbl))

      return(ret)
    }

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
  ret <- suppressWarnings(purrr::possibly(broom::tidy, NULL)(m))

  colnames(ret) <- c("item1", "item2", "value")
  ret
}
