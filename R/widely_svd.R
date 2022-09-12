#' Turn into a wide matrix, perform SVD, return to tidy form
#'
#' This is useful for dimensionality reduction of items, especially when setting a
#' lower nv.
#'
#' @name widely_svd
#'
#' @param tbl Table
#' @param item Item to perform dimensionality reduction on; will end up in `item` column
#' @param feature Column describing the feature that links one item to others.
#' @param value Value
#' @param nv Optional; the number of principal components to estimate. Recommended for matrices
#' with many features.
#' @param weight_d Whether to multiply each value by the `d` principal component.
#' @param ... Extra arguments passed to `svd` (if `nv` is `NULL`)
#' or `irlba` (if `nv` is given)
#'
#' @return A tbl_df with three columns. The first is retained from the `item` input,
#' then `dimension` and `value`. Each row represents one principal component
#' value.
#'
#' @examples
#'
#' library(dplyr)
#' library(gapminder)
#'
#' # principal components driving change
#' gapminder_svd <- gapminder %>%
#'   widely_svd(country, year, lifeExp)
#'
#' gapminder_svd
#'
#' # compare SVDs, join with other data
#' library(ggplot2)
#' library(tidyr)
#'
#' gapminder_svd %>%
#'   spread(dimension, value) %>%
#'   inner_join(distinct(gapminder, country, continent), by = "country") %>%
#'   ggplot(aes(`1`, `2`, label = country)) +
#'   geom_point(aes(color = continent)) +
#'   geom_text(vjust = 1, hjust = 1)
#'
#' @export
widely_svd <- function(tbl, item, feature, value, nv = NULL, weight_d = FALSE, ...) {
  widely_svd_(tbl,
              col_name(substitute(item)),
              col_name(substitute(feature)),
              col_name(substitute(value)),
              nv = nv,
              weight_d = weight_d,
              ...)
}


#' @rdname widely_svd
#' @export
widely_svd_ <- function(tbl, item, feature, value, nv = NULL, weight_d = FALSE, ...) {
  if (is.null(nv)) {
    perform_svd <- function(m) {
      s <- svd(m, ...)

      if (weight_d) {
        ret <- t(s$d * t(s$u))
      } else {
        ret <- s$u
      }

      rownames(ret) <- rownames(m)
      ret
    }
    sparse <- FALSE
  } else {
    if (!requireNamespace("irlba", quietly = TRUE)) {
      stop("Requires the irlba package")
    }
    perform_svd <- function(m) {
      s <- irlba::irlba(m, nv = nv, ...)
      if (weight_d) {
        ret <- t(s$d * t(s$u))
      } else {
        ret <- s$u
      }

      rownames(ret) <- rownames(m)
      ret
    }
    sparse <- TRUE
  }

  item_vals <- tbl[[item]]
  item_u <- unique(item_vals)
  tbl[[item]] <- match(item_vals, item_u)

  ret <- widely_(perform_svd, sparse = sparse)(tbl, item, feature, value)

  ret <- ret %>%
    transmute(item = item_u[as.integer(item1)],
              dimension = item2,
              value)

  colnames(ret)[1] <- item

  ret
}
