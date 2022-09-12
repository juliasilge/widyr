#' Cosine similarity of pairs of items
#'
#' Compute cosine similarity of all pairs of items in a tidy table.
#'
#' @param tbl Table
#' @param item Item to compare; will end up in `item1` and
#' `item2` columns
#' @param feature Column describing the feature that links one item to others
#' @param value Value
#' @param ... Extra arguments passed on to [squarely()],
#' such as `diag` and `upper`
#'
#' @seealso [squarely()]
#'
#' @examples
#'
#' library(janeaustenr)
#' library(dplyr)
#' library(tidytext)
#'
#' # Comparing Jane Austen novels
#' austen_words <- austen_books() %>%
#'   unnest_tokens(word, text) %>%
#'   anti_join(stop_words, by = "word") %>%
#'   count(book, word) %>%
#'   ungroup()
#'
#' # closest books to each other
#' closest <- austen_words %>%
#'   pairwise_similarity(book, word, n) %>%
#'   arrange(desc(similarity))
#'
#' closest
#'
#' closest %>%
#'   filter(item1 == "Emma")
#'
#' @export
pairwise_similarity <- function(tbl, item, feature, value, ...) {
  pairwise_similarity_(tbl,
                 col_name(substitute(item)),
                 col_name(substitute(feature)),
                 col_name(substitute(value)), ...)
}


#' @rdname pairwise_similarity
#' @export
pairwise_similarity_ <- function(tbl, item, feature, value, ...) {
  m <- matrix(1:9, ncol = 3)
  d_func <- squarely_(function(m) {
    normed <- m / sqrt(rowSums(m ^ 2))
    normed %*% t(normed)
  }, sparse = TRUE, ...)

  tbl %>%
    d_func(item, feature, value) %>%
    rename(similarity = value)
}
