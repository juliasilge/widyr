#' Count pairs of items within a group
#'
#' Count the number of times each pair of items appear together within a group
#' defined by "feature." For example, this could count the number of times
#' two words appear within documents).
#'
#' @param tbl Table
#' @param item Item to count pairs of; will end up in \code{item1} and
#' \code{item2} columns
#' @param feature Column within which to count pairs
#' \code{item2} columns
#' @param wt Optionally a weight column, which should have a consistent weight
#' for each feature
#' @param ... Extra arguments passed on to \code{squarely},
#' such as \code{diag}, \code{upper}, and \code{sort}
#'
#' @seealso \code{\link{squarely}}
#'
#' @examples
#'
#' library(dplyr)
#' dat <- data_frame(group = rep(1:5, each = 2),
#'                   letter = c("a", "b",
#'                              "a", "c",
#'                              "a", "c",
#'                              "b", "e",
#'                              "b", "f"))
#'
#' # count the number of times two letters appear together
#' pairwise_count(dat, letter, group)
#' pairwise_count(dat, letter, group, sort = TRUE)
#' pairwise_count(dat, letter, group, sort = TRUE, diag = FALSE)
#'
#' @export
pairwise_count <- function(tbl, item, feature, wt = NULL, ...) {
  pairwise_count_(tbl,
                  col_name(substitute(item)),
                  col_name(substitute(feature)),
                  wt = col_name(substitute(wt)),
                  ...)
}


#' @rdname pairwise_count
#' @export
pairwise_count_ <- function(tbl, item, feature, wt = NULL, ...) {
  if (is.null(wt)) {
    func <- squarely_(function(m) m %*% t(m), sparse = TRUE, ...)
    wt <- "..value"
  } else {
    func <- squarely_(function(m) m %*% t(m > 0), sparse = TRUE, ...)
  }

  tbl %>%
    distinct_(.dots = c(item, feature), .keep_all = TRUE) %>%
    mutate(..value = 1) %>%
    func(item, feature, wt) %>%
    rename(n = value)
}
