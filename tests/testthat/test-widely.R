context("widely")

test_that("widely can widen, operate, and re-tidy", {
  if (require("gapminder", quietly = TRUE)) {
    ret <- gapminder %>%
      widely(cor, year, country, lifeExp)()

    expect_is(ret$item1, "character")
    expect_is(ret$item2, "character")
  }
})

test_that("widely's maximum size argument works", {
  f <- function() {
    widely(cor, year, country, lifeExp, maximum_size = 1000)(gapminder)
  }
  expect_error(f(), "1704.*large")
})
