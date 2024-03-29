% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pairwise_similarity.R
\name{pairwise_similarity}
\alias{pairwise_similarity}
\alias{pairwise_similarity_}
\title{Cosine similarity of pairs of items}
\usage{
pairwise_similarity(tbl, item, feature, value, ...)

pairwise_similarity_(tbl, item, feature, value, ...)
}
\arguments{
\item{tbl}{Table}

\item{item}{Item to compare; will end up in \code{item1} and
\code{item2} columns}

\item{feature}{Column describing the feature that links one item to others}

\item{value}{Value}

\item{...}{Extra arguments passed on to \code{\link[=squarely]{squarely()}},
such as \code{diag} and \code{upper}}
}
\description{
Compute cosine similarity of all pairs of items in a tidy table.
}
\examples{

library(janeaustenr)
library(dplyr)
library(tidytext)

# Comparing Jane Austen novels
austen_words <- austen_books() \%>\%
  unnest_tokens(word, text) \%>\%
  anti_join(stop_words, by = "word") \%>\%
  count(book, word) \%>\%
  ungroup()

# closest books to each other
closest <- austen_words \%>\%
  pairwise_similarity(book, word, n) \%>\%
  arrange(desc(similarity))

closest

closest \%>\%
  filter(item1 == "Emma")

}
\seealso{
\code{\link[=squarely]{squarely()}}
}
