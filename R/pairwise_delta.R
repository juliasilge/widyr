#' Delta measure of pairs of documents
#'
#' Compute the delta distances (from its two variants) of all pairs of documents in a tidy table.
#'
#' @param tbl Table
#' @param item Item to compare; will end up in \code{item1} and
#' \code{item2} columns
#' @param feature Column describing the feature that links one item to others
#' @param value Value
#' @param method Distance measure to be used; see \code{\link{dist}}
#' @param ... Extra arguments passed on to \code{\link{squarely}},
#' such as \code{diag} and \code{upper}
#'
#' @seealso \code{\link{squarely}}
#'
#' @examples
#'
#' library(janeaustenr)
#' library(dplyr)
#' library(tidytext)
#'
#' # closest documents in terms of 1000 most frequent words
#' closest <- austen_books() %>%
#'   unnest_tokens(word, text) %>%
#'   count(book, word) %>%
#'   top_n(1000, n) %>%
#'   pairwise_delta(book, word, n, method = "burrows") %>%
#'   arrange(delta)
#'
#' closest
#'
#' closest %>%
#'   filter(item1 == "Pride & Prejudice")
#'
#' # to remove duplicates, use upper = FALSE
#' closest <- austen_books() %>%
#'   unnest_tokens(word, text) %>%
#'   count(book, word) %>%
#'   top_n(1000, n) %>%
#'   pairwise_delta(book, word, n, method = "burrows", upper = FALSE) %>%
#'   arrange(delta)
#'
#' # Can also use Argamon's Linear Delta
#' closest <- austen_books() %>%
#'   unnest_tokens(word, text) %>%
#'   count(book, word) %>%
#'   top_n(1000, n) %>%
#'   pairwise_delta(book, word, n, method = "argamon", upper = FALSE) %>%
#'   arrange(delta)
#'
#' @export
pairwise_delta <- function(tbl, item, feature, value,
                           method = "burrows", ...) {
  pairwise_delta_(tbl,
                  col_name(substitute(item)),
                  col_name(substitute(feature)),
                  col_name(substitute(value)),
                  method = method, ...)
}


#' @rdname pairwise_delta
#' @export
pairwise_delta_ <- function(tbl, item, feature, value, method = "burrows", ...) {
  delta_func <- function(m) {

    if(method == "burrows") {
      dist_method = "manhattan"
    }
    else if(method == "argamon") {
      dist_method = "euclidean"
    }
    else {
      stop("Wrong method! Only method = burrows or method = argamon have been implmented!")
    }

    return(as.matrix(stats::dist(scale(m), method = dist_method)/length(m[1,])))
  }

  d_func <- squarely_(delta_func, ...)

  tbl %>%
    d_func(item, feature, value) %>%
    rename(delta = value)
}
