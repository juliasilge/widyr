#' Cluster items based on k-means across features
#'
#' Given a tidy table of features describing each item, perform k-means
#' clustering using \code{\link{kmeans}} and retidy the data into
#' one-row-per-cluster.
#'
#' @param tbl Table
#' @param item Item to cluster (as a bare column name)
#' @param feature Feature column (dimension in clustering)
#' @param value Value column
#' @param k Number of clusters
#' @param fill What to fill in for missing values
#' @param ... Other arguments passed on to \code{\link{kmeans}}
#'
#' @seealso \code{\link{widely_hclust}}
#'
#' @importFrom rlang :=
#'
#' @examples
#'
#' library(gapminder)
#' library(dplyr)
#'
#' clusters <- gapminder %>%
#'   widely_kmeans(country, year, lifeExp, k = 5)
#'
#' clusters
#'
#' clusters %>%
#'   count(cluster)
#'
#' # Examine a few clusters
#' clusters %>% filter(cluster == 1)
#' clusters %>% filter(cluster == 2)
#'
#' @export
widely_kmeans <- function(tbl, item, feature, value, k, fill = 0, ...) {
  item_str <- as.character(substitute(item))
  feature_str <- as.character(substitute(feature))
  value_str <- as.character(substitute(value))

  form <- stats::as.formula(paste(item_str, "~", feature_str))

  m <- tbl %>%
    reshape2::acast(form, value.var = value_str, fill = fill)

  clustered <- stats::kmeans(m, k, ...)

  # Add the clusters to the original table
  i <- match(rownames(m), as.character(tbl[[item_str]]))
  tibble::tibble(!!sym(item_str) := tbl[[item_str]][i],
                 cluster = factor(clustered$cluster)) %>%
    dplyr::arrange(cluster)
}
