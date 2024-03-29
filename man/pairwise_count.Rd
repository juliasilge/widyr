% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pairwise_count.R
\name{pairwise_count}
\alias{pairwise_count}
\alias{pairwise_count_}
\title{Count pairs of items within a group}
\usage{
pairwise_count(tbl, item, feature, wt = NULL, ...)

pairwise_count_(tbl, item, feature, wt = NULL, ...)
}
\arguments{
\item{tbl}{Table}

\item{item}{Item to count pairs of; will end up in \code{item1} and
\code{item2} columns}

\item{feature}{Column within which to count pairs
\code{item2} columns}

\item{wt}{Optionally a weight column, which should have a consistent weight
for each feature}

\item{...}{Extra arguments passed on to \code{squarely},
such as \code{diag}, \code{upper}, and \code{sort}}
}
\description{
Count the number of times each pair of items appear together within a group
defined by "feature." For example, this could count the number of times
two words appear within documents).
}
\examples{

library(dplyr)
dat <- tibble(group = rep(1:5, each = 2),
              letter = c("a", "b",
                         "a", "c",
                         "a", "c",
                         "b", "e",
                         "b", "f"))

# count the number of times two letters appear together
pairwise_count(dat, letter, group)
pairwise_count(dat, letter, group, sort = TRUE)
pairwise_count(dat, letter, group, sort = TRUE, diag = TRUE)

}
\seealso{
\code{\link[=squarely]{squarely()}}
}
