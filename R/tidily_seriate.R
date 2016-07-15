#' Use seriation to order variables for wide display
#'
#' Turn variables into ordered factors based on seriation, which finds a linear
#' order that minimizes distances between rows and/or columns.
#'
#' @param tbl Table
#' @param item Item to compare; will end up in \code{item1} and
#' \code{item2} columns
#' @param feature Column describing the feature that links one item to others
#' @param value Value
#' @param reorder A vector of whether the item (1) or the feature (2) should be
#' reordered. Default is \code{c(1, 2)} (reorder both)
#' @param method Seriation method; see \code{\link[seriation]{seriate}}
#' @param ... Extra arguments passed on to \code{\link[seriation]{seriate}}
#'
#' @return A tbl with the same dimensions as the input table, but with the
#' item and/or feature column changed to an ordered factor in the order
#' determined by seriation.
#'
#' @examples
#'
#' library(gapminder)
#' library(ggplot2)
#'
#' # without seriation
#' gapminder %>%
#'   ggplot(aes(year, country, fill = lifeExp)) +
#'   geom_tile()
#'
#' # with seriation
#' gapminder %>%
#'   tidily_seriate(year, country, lifeExp) %>%
#'   ggplot(aes(year, country, fill = lifeExp)) +
#'   geom_tile()
#'
#' #
#'
#' @export
tidily_seriate <- function(tbl, item, feature, value, reorder = c(1, 2), method = "PCA", ...) {
  tidily_seriate_(tbl,
                 col_name(substitute(item)),
                 col_name(substitute(feature)),
                 col_name(substitute(value)),
                 reorder = reorder,
                 method = method, ...)
}


#' @rdname tidily_seriate
#' @export
tidily_seriate_ <- function(tbl, item, feature, value, reorder = reorder, method = "PCA", ...) {
  form <- as.formula(paste(item, feature, sep = " ~ "))
  m <- reshape2::acast(tbl, form, value.var = value)
  s <- seriate(m, margin = reorder, method = method, ...)

  if (1 %in% reorder) {
    o <- get_order(s, 1)
    tbl[[item]] <- factor(tbl[[item]], levels = rownames(m)[o])
  }
  if (2 %in% reorder) {
    o <- get_order(s, length(reorder))
    tbl[[feature]] <- factor(tbl[[feature]], levels = colnames(m)[o])
  }
  tbl
}
