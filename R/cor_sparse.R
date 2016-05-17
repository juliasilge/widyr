#' Find the Pearson correlation of a sparse matrix efficiently
#'
#' Find the Pearson correlation of a sparse matrix.
#' For large sparse matrix this is more efficient in time and memory than
#' \code{cor(as.matrix(x))}. Note that it does not currently work on
#' simple_triplet_matrix objects.
#'
#' @param x A matrix, potentially a sparse matrix such as a "dgTMatrix" object
#'
#' @source This code comes from mike on this Stack Overflow answer:
#' \url{http://stackoverflow.com/a/9626089/712603}.
cor_sparse <- function(x) {
  n <- nrow(x)
  covmat <- (as.matrix(crossprod(x)) - n * tcrossprod(colMeans(x))) / (n - 1)
  cormat <- covmat / tcrossprod(sqrt(diag(covmat)))
  cormat
}
