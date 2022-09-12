#' Pointwise mutual information of pairs of items
#'
#' Find pointwise mutual information of pairs of items in a column, based on
#' a "feature" column that links them together.
#' This is an example of the spread-operate-retidy pattern.
#'
#' @param tbl Table
#' @param item Item to compare; will end up in `item1` and
#' `item2` columns
#' @param feature Column describing the feature that links one item to others
#' @param sort Whether to sort in descending order of the pointwise mutual
#' information
#' @param ... Extra arguments passed on to `squarely`,
#' such as `diag` and `upper`
#'
#' @name pairwise_pmi
#'
#' @return A tbl_df with three columns, `item1`, `item2`, and
#' `pmi`.
#'
#' @examples
#'
#' library(dplyr)
#'
#' dat <- tibble(group = rep(1:5, each = 2),
#'               letter = c("a", "b",
#'                          "a", "c",
#'                          "a", "c",
#'                          "b", "e",
#'                          "b", "f"))
#'
#' # how informative is each letter about each other letter
#' pairwise_pmi(dat, letter, group)
#' pairwise_pmi(dat, letter, group, sort = TRUE)
#'
#' @export
pairwise_pmi <- function(tbl, item, feature, sort = FALSE, ...) {
  pairwise_pmi_(tbl,
                col_name(substitute(item)),
                col_name(substitute(feature)),
                sort = sort, ...)
}


#' @rdname pairwise_pmi
#' @export
pairwise_pmi_ <- function(tbl, item, feature, sort = FALSE, ...) {
  f <- function(m) {
    row_sums <- rowSums(m) / sum(m)

    ret <- m %*% t(m)
    ret <- ret / sum(ret)
    ret <- ret / row_sums
    ret <- t(t(ret) / (row_sums))
    ret
  }
  pmi_func <- squarely_(f, sparse = TRUE, sort = sort, ...)

  tbl %>%
    ungroup() %>%
    mutate(..value = 1) %>%
    pmi_func(item, feature, "..value") %>%
    mutate(value = log(value)) %>%
    rename(pmi = value)
}
