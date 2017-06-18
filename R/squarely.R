#' A special case of the widely adverb for creating tidy
#' square matrices
#'
#' A special case of \code{\link{widely}}. Used to pre-prepare and
#' post-tidy functions that take an m x n (m items, n features)
#' matrix and return an m x m (item x item) matrix, such as a
#' distance or correlation matrix.
#'
#' @param .f Function to wrap
#' @param diag Whether to include diagonal (i = j) in output
#' @param upper Whether to include upper triangle, which may be
#' duplicated
#' @param ... Extra arguments passed on to \code{widely}
#'
#' @return Returns a function that takes at least four arguments:
#'   \item{tbl}{A table}
#'   \item{item}{Name of column to use as rows in wide matrix}
#'   \item{feature}{Name of column to use as columns in wide matrix}
#'   \item{feature}{Name of column to use as values in wide matrix}
#'   \item{...}{Arguments passed on to inner function}
#'
#' @seealso \code{\link{widely}}, \code{\link{pairwise_count}},
#' \code{\link{pairwise_cor}}, \code{\link{pairwise_dist}}
#'
#' @examples
#'
#' library(dplyr)
#' library(gapminder)
#'
#' closest_continent <- gapminder %>%
#'   group_by(continent) %>%
#'   squarely(dist)(country, year, lifeExp)
#'
#' @export
squarely <- function(.f, diag = FALSE, upper = TRUE, ...) {
  inner_func <- squarely_(.f, diag = diag, upper = upper, ...)
  function(tbl, item, feature, value, ...) {
    inner_func(tbl,
               col_name(substitute(item)),
               col_name(substitute(feature)),
               col_name(substitute(value)),
               ...)
  }
}


#' @rdname squarely
#' @export
squarely_ <- function(.f, diag = FALSE,
                      upper = TRUE,
                      ...) {
  extra_args <- list(...)

  f <- function(tbl, item, feature, value, ...) {
    if (inherits(tbl, "grouped_df")) {
      # perform within each group, then restore groups
      ret <- tbl %>%
        tidyr::nest_("..data", nest_cols = c(item, feature, value)) %>%
        mutate(..data = purrr::map(..data, f, item, feature, value)) %>%
        tidyr::unnest_("..data") %>%
        group_by_(.dots = dplyr::groups(tbl))

      return(ret)
    }

    item_vals <- tbl[[item]]
    item_u <- unique(item_vals)

    tbl[[item]] <- match(item_vals, item_u)

    new_f <- do.call(widely_, c(list(.f), extra_args))
    ret <- new_f(tbl, item, feature, value, ...)

    ret$item1 <- as.integer(ret$item1)
    ret$item2 <- as.integer(ret$item2)

    if (!upper) {
      ret <- filter(ret, item1 <= item2)
    }
    if (!diag) {
      ret <- filter(ret, item1 != item2)
    }

    ret$item1 <- item_u[ret$item1]
    ret$item2 <- item_u[ret$item2]

    ret
  }
  f
}
