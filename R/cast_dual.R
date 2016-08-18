#' Cast a item-feature dataset into a wide matrix while keeping the table
#'
#' Often one wants to use three columns (item, feature, value) of a tidy
#' table to cast into a wide matrix, but still keep additional columns of
#' the table in line with the matrix. This is particularly relevant for
#' classification and clustering applications, where additional columns
#' may contain the true class of each item or additional information
#' useful for examining a model afterwards.
#'
#' @param tbl A table
#' @param item A column to use as rows in the resulting matrix. One
#' item
#' @param feature A column to use as columns in the resulting matrix
#' @param value A column to use as the value in the resulting matrix. If
#' missing, will use 1 (a binary matrix).
#' @param sparse Whether to cast into a sparse matrix
#'
#' @return A list of class "cast_tbl", with two components:
#'   \item{tbl}{A one-item-per-row table, containing the first instance of
#'   each item from the original table}
#'   \item{matrix}{An item-by-feature matrix whose rows line up with the
#'   rows of the table}
#'
#' @examples
#'
#' library(gapminder)
#' library(dplyr)
#'
#' cast_tbl <- gapminder %>%
#'   select(country, continent, year, lifeExp) %>%
#'   cast_dual(country, year, lifeExp, sparse = FALSE)
#'
#' # one row per item in the table
#' cast_tbl$tbl
#'
#' # one row per item in the matrix as well
#' head(cast_tbl$matrix)
#'
#' @export
cast_dual <- function(tbl, item, feature, value, sparse = TRUE) {
  if (missing(value)) {
    tbl$..value <- 1
    val <- "..value"
  } else {
    val <- col_name(substitute(value))
  }

  cast_dual_(tbl,
             col_name(substitute(item)),
             col_name(substitute(feature)),
             val, sparse = sparse)
}


#' @rdname cast_dual
#' @export
cast_dual_ <- function(tbl, item, feature, value, sparse = TRUE) {
  item_vals <- tbl[[item]]
  item_u <- unique(item_vals)
  tbl[[item]] <- match(item_vals, item_u)

  if (sparse) {
    m <- tidytext::cast_sparse_(tbl, item, feature, value)
  } else {
    form <- as.formula(paste(item, feature, sep = "~"))
    m <- reshape2::acast(tbl, form, value.var = value)
  }
  mat_indices <- as.numeric(rownames(m))
  item_order <- item_u[mat_indices]
  rownames(m) <- as.character(item_order)

  tbl[[feature]] <- NULL
  tbl[[value]] <- NULL
  tbl <- tbl[mat_indices, ]
  tbl[[item]] <- item_order

  ret <- list(tbl = tbl, matrix = m)
  class(ret) <- "cast_tbl"
  ret
}
