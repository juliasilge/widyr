#' Comes from tidyr
#' @noRd
col_name <- function(x, default = stop("Please supply column name", call. = FALSE))
{
  if (is.character(x))
    return(x)
  if (identical(x, quote(expr = )))
    return(default)
  if (is.name(x))
    return(as.character(x))
  if (is.null(x))
    return(x)
  stop("Invalid column specification", call. = FALSE)
}


#' These tidiers are duplicated from the development version of broom
#' and will be removed in the future
#' @noRd
tidy.dgTMatrix <- function(x, ...) {
  s <- Matrix::summary(x)

  row <- s$i
  if (!is.null(rownames(x))) {
    row <- rownames(x)[row]
  }
  col <- s$j
  if (!is.null(colnames(x))) {
    col <- colnames(x)[col]
  }

  ret <- data.frame(row = row, column = col, value = s$x,
                    stringsAsFactors = FALSE)
  ret
}


#' @noRd
tidy.dgCMatrix <- function(x, ...) {
  tidy(methods::as(x, "dgTMatrix"))
}
