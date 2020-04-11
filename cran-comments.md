## Changes

### Fixes

* Update to work with the latest version of tidytext's cast_sparse. Adds rlang to IMPORTs. (@juliasilge, #30)
* Update from data_frame() to tibble() in examples

### Maintenance

* Removed topicmodels from SUGGESTS (hasn't been required for several versions)
* Fixed spelling mistakes of occurence->occurrence

## Test environments
* local OS X install, R 3.6.1
* ubuntu 12.04 (on travis-ci), devel, release, oldrel
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

Reverse imports: akc and saotd
Reverse depends: wikisourcer

All passed R CMD CHECK with the new version of widyr.
