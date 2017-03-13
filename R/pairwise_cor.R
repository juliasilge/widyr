#' Correlations of pairs of items
#'
#' Find correlations of pairs of items in a column, based on a "feature" column
#' that links them together. This is an example of the spread-operate-retidy pattern.
#'
#' @param tbl Table
#' @param item Item to compare; will end up in \code{item1} and
#' \code{item2} columns
#' @param feature Column describing the feature that links one item to others
#' @param value Value column. If not given, defaults to all values being 1 (thus
#' a binary correlation)
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
#' # United Nations voting data
#' library(unvotes)
#'
#' country_cors <- un_votes %>%
#'   mutate(vote = as.numeric(vote)) %>%
#'   pairwise_cor(country, rcid, vote, sort = TRUE)
#'
#' country_cors
#'
#' @export
pairwise_cor <- function(tbl, item, feature, value,
                     method = c("pearson", "kendall", "spearman"),
                     use = "everything", ...) {
  if (missing(value)) {
    tbl$..value <- 1
    val <- "..value"
  } else {
    val <- col_name(substitute(value))
  }

  pairwise_cor_(tbl,
            col_name(substitute(item)),
            col_name(substitute(feature)),
            val,
            method = method, use = use, ...)
}


#' @rdname pairwise_cor
#' @export
pairwise_cor_ <- function(tbl, item, feature, value,
                      method = c("pearson", "kendall", "spearman"),
                      use = "everything",
                      ...) {
  method <- match.arg(method)

  sparse <- (method == "pearson" & use == "everything")
  f <- if (sparse) {
    function(x) cor_sparse(t(x))
  } else {
    function(x) stats::cor(t(x), method = method, use = use)
  }
  cor_func <- squarely_(f, sparse = sparse, ...)

  tbl %>%
    ungroup() %>%
    cor_func(item, feature, value) %>%
    rename(correlation = value)
}
