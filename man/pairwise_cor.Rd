% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pairwise_cor.R
\name{pairwise_cor}
\alias{pairwise_cor}
\alias{pairwise_cor_}
\title{Correlations of pairs of items}
\usage{
pairwise_cor(
  tbl,
  item,
  feature,
  value,
  method = c("pearson", "kendall", "spearman"),
  use = "everything",
  ...
)

pairwise_cor_(
  tbl,
  item,
  feature,
  value,
  method = c("pearson", "kendall", "spearman"),
  use = "everything",
  ...
)
}
\arguments{
\item{tbl}{Table}

\item{item}{Item to compare; will end up in \code{item1} and
\code{item2} columns}

\item{feature}{Column describing the feature that links one item to others}

\item{value}{Value column. If not given, defaults to all values being 1 (thus
a binary correlation)}

\item{method}{Correlation method}

\item{use}{Character string specifying the behavior of correlations
with missing values; passed on to \code{cor}}

\item{...}{Extra arguments passed on to \code{squarely},
such as \code{diag} and \code{upper}}
}
\description{
Find correlations of pairs of items in a column, based on a "feature" column
that links them together. This is an example of the spread-operate-retidy pattern.
}
\examples{

library(dplyr)
library(gapminder)

gapminder \%>\%
  pairwise_cor(country, year, lifeExp)

gapminder \%>\%
  pairwise_cor(country, year, lifeExp, sort = TRUE)

# United Nations voting data
if (require("unvotes", quietly = TRUE)) {
  country_cors <- un_votes \%>\%
    mutate(vote = as.numeric(vote)) \%>\%
    pairwise_cor(country, rcid, vote, sort = TRUE)
}

}
