# widyr 0.1.5

* Change maintainer to Julia Silge
* Updates for new Matrix package version (@simonpcouch, #41)
* Update use of `distinct()`

# widyr 0.1.4

* Fix bug in United Nations vignette (caused by unvotes update).
* Also changes the vignettes to render conditionally on package installation.

# widyr 0.1.3

* Update to work with the latest version of tidytext's cast_sparse. Adds rlang to IMPORTs. (@juliasilge, #30)
* Update from data_frame() to tibble() in examples
* Removed topicmodels from SUGGESTS (hasn't been required for several versions)
* Fixed spelling mistakes of occurence->occurrence

# widyr 0.1.2

* Fixes to be compatible with tidyr v1.0.0, while also being reverse-compatible with previous versions of tidyr.
* Fix intro vignette index entry

# widyr 0.1.1

* Added `pairwise_delta` function for Burrows' delta
* Added `pairwise_pmi` for pairwise mutual information
* Added `widely_svd` for performing singular value decomposition then re-tidying
* Removed methods from DESCRIPTION

# widyr 0.1.0

* Initial release of package
* Only functions are the pairwise_ collection of functions, as well as the widely and squarely adverbs.
