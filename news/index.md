# Changelog

## widyr (development version)

- Now force evaluation for
  [`widely()`](https://juliasilge.github.io/widyr/reference/widely.md)
  function factory (thanks to [@lhdjung](https://github.com/lhdjung),
  [\#44](https://github.com/juliasilge/widyr/issues/44))
- Explain how to handle zero-similarity pairs in
  [`pairwise_similarity()`](https://juliasilge.github.io/widyr/reference/pairwise_similarity.md)
  ([\#47](https://github.com/juliasilge/widyr/issues/47))

## widyr 0.1.5

CRAN release: 2022-09-13

- Change maintainer to Julia Silge
- Updates for new Matrix package version
  ([@simonpcouch](https://github.com/simonpcouch),
  [\#41](https://github.com/juliasilge/widyr/issues/41))
- Update use of
  [`distinct()`](https://dplyr.tidyverse.org/reference/distinct.html)

## widyr 0.1.4

CRAN release: 2021-08-12

- Fix bug in United Nations vignette (caused by unvotes update).
- Also changes the vignettes to render conditionally on package
  installation.

## widyr 0.1.3

CRAN release: 2020-04-12

- Update to work with the latest version of tidytext’s cast_sparse. Adds
  rlang to IMPORTs. ([@juliasilge](https://github.com/juliasilge),
  [\#30](https://github.com/juliasilge/widyr/issues/30))
- Update from data_frame() to tibble() in examples
- Removed topicmodels from SUGGESTS (hasn’t been required for several
  versions)
- Fixed spelling mistakes of occurence-\>occurrence

## widyr 0.1.2

CRAN release: 2019-09-09

- Fixes to be compatible with tidyr v1.0.0, while also being
  reverse-compatible with previous versions of tidyr.
- Fix intro vignette index entry

## widyr 0.1.1

CRAN release: 2018-03-11

- Added `pairwise_delta` function for Burrows’ delta
- Added `pairwise_pmi` for pairwise mutual information
- Added `widely_svd` for performing singular value decomposition then
  re-tidying
- Removed methods from DESCRIPTION

## widyr 0.1.0

CRAN release: 2017-08-14

- Initial release of package
- Only functions are the pairwise\_ collection of functions, as well as
  the widely and squarely adverbs.
