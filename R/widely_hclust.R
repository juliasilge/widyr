#' Cluster pairs of items into groups using hierarchical clustering
#'
#' Reshape a table that represents pairwise distances into hierarchical clusters,
#' returning a table with \code{item} and \code{cluster} columns.
#'
#' @param tbl Table
#' @param item1 First item
#' @param item2 Second item
#' @param distance Distance column
#' @param k The desired number of groups
#' @param h Height at which to cut the hierarchically clustered tree
#'
#' @examples
#'
#' library(gapminder)
#' library(dplyr)
#'
#' # Construct Euclidean distances between countries based on life
#' # expectancy over time
#' country_distances <- gapminder %>%
#'   pairwise_dist(country, year, lifeExp)
#'
#' country_distances
#'
#' # Turn this into 5 hierarchical clusters
#' clusters <- country_distances %>%
#'   widely_hclust(item1, item2, distance, k = 8)
#'
#' # Examine a few such clusters
#' clusters %>% filter(cluster == 1)
#' clusters %>% filter(cluster == 2)
#'
#' @seealso \link{cutree}
#'
#' @export
widely_hclust <- function(tbl, item1, item2, distance, k = NULL, h = NULL) {
  col1_str <- as.character(substitute(item1))
  col2_str <- as.character(substitute(item2))
  dist_str <- as.character(substitute(distance))

  unique_items <- unique(c(as.character(tbl[[col1_str]]), as.character(tbl[[col2_str]])))

  form <- stats::as.formula(paste(col1_str, "~", col2_str))

  max_distance <- max(tbl[[dist_str]])

  tibble(item1 = match(tbl[[col1_str]], unique_items),
         item2 = match(tbl[[col2_str]], unique_items),
         distance = tbl[[dist_str]]) %>%
    reshape2::acast(item1 ~ item2, value.var = "distance", fill = max_distance) %>%
    stats::as.dist() %>%
    stats::hclust() %>%
    stats::cutree(k = k, h = h) %>%
    tibble::enframe("item", "cluster") %>%
    dplyr::mutate(item = unique_items[as.integer(item)],
                  cluster = factor(cluster)) %>%
    dplyr::arrange(cluster)
}
