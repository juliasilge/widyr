#' Correlations of pairs of items
#'
#' @param tbl Table
#' @param item Item to compare; will end up in \code{item1} and
#' \code{item2} columns
#' @param feature Column describing the feature that links one item to others
#' @param value Value
#' @param method Correlation method
#' @param use Character string specifying the behavior of correlations
#' with missing values; passed on to \code{cor}
#' @param ... Extra arguments passed on to \code{squarely},
#' such as \code{diag} and \code{upper}
#'
#' @examples
#'
#' library(dplyr)
#' library(gapminder)
#'
#' gapminder %>%
#'   pairwise_cor(country, year, lifeExp)
#'
#' gapminder %>%
#'   pairwise_cor(country, year, lifeExp, sort = TRUE)
#'
#' @export
pairwise_cor <- function(tbl, item, feature, value,
                     method = c("pearson", "kendall", "spearman"),
                     use = "everything", ...) {
  pairwise_cor_(tbl,
            col_name(substitute(item)),
            col_name(substitute(feature)),
            col_name(substitute(value)),
            method = method, use = use, ...)
}


#' @rdname pairwise_cor
#' @export
pairwise_cor_ <- function(tbl, item, feature, value,
                      method = c("pearson", "kendall", "spearman"),
                      use = "everything",
                      ...) {
  method <- match.arg(method)

  f <- if (method == "pearson") {
    if (use != "everything") {
      stop("Currently cannot support any use argument besides everything ",
           "when method = 'pearson'")
    }
    function(x) cor_sparse(t(x))
  } else {
    function(x) stats::cor(t(x), method = method, use = use)
  }
  cor_func <- squarely_(f, item, feature, value,
                        sparse = (method == "pearson"), ...)

  tbl %>%
    ungroup() %>%
    cor_func() %>%
    rename(correlation = value)
}
