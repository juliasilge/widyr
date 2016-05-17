#' Correlations of pairs of items
#'
#' @param tbl Table
#' @param group Group within which to look for correlations
#' @param item Item to compare; will end up in \code{item1} and
#' \code{item2} columns
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
#' library(tidytext)
#'
#' data(AssociatedPress, package = "topicmodels")
#' ap_terms <- tidy(AssociatedPress) %>%
#'   group_by(term) %>%
#'   filter(n() >= 50)
#'
#' ap_terms %>%
#'   pairwise_cor(document, term, count, sort = TRUE, upper = FALSE)
#'
#' @export
pairwise_cor <- function(tbl, group, item, value,
                     method = c("pearson", "kendall", "spearman"),
                     use = "everything", ...) {
  pairwise_cor_(tbl,
            col_name(substitute(group)),
            col_name(substitute(item)),
            col_name(substitute(value)),
            method = method, use = use, ...)
}


#' @rdname pairwise_cor
#' @export
pairwise_cor_ <- function(tbl, group, item, value,
                      method = c("pearson", "kendall", "spearman"),
                      use = "everything",
                      ...) {
  method <- match.arg(method)

  f <- if (method == "pearson") {
    if (use != "everything") {
      stop("Currently cannot support any use argument besides everything ",
           "when method = 'pearson'")
    }
    cor_sparse
  } else {
    function(x) stats::cor(x, method = method, use = use)
  }
  cor_func <- squarely_(f, group, item, value,
                        sparse = (method == "pearson"), ...)

  tbl %>%
    ungroup() %>%
    cor_func() %>%
    rename(correlation = value)
}
