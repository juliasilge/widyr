#' Turn into a wide matrix, perform SVD, return to tidy form
#'
#' This is useful for dimensionality reduction. Work in progress.
#'
#' @name widely_svd
#'
#' @param tbl Table
#' @param item Item to perform dimensionality reduction on; will end up in \code{item} column
#' @param feature Column describing the feature that links one item to others.
#' @param value Value
#' @param rank Optional; the maximum dimensionality of the data. Recommended for matrices
#' with many features.
#'
#' @export
widely_svd <- function(tbl, item, feature, value, rank = NULL) {
  widely_svd_(tbl,
              col_name(substitute(item)),
              col_name(substitute(feature)),
              col_name(substitute(value)),
              rank = rank)
}


#' @rdname widely_svd
#' @export
widely_svd_ <- function(tbl, item, feature, value, rank = NULL) {
  if (is.null(rank)) {
    perform_svd <- function(m) {
      ret <- svd(m)$u
      rownames(ret) <- rownames(m)
      ret
    }
    sparse <- FALSE
  } else {
    if (!requireNamespace("irlba", quietly = TRUE)) {
      stop("Requires the irlba package")
    }
    perform_svd <- function(m) {
      ret <- irlba::irlba(m, nv = rank)$u
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
