context("widely")

test_that("widely can widen, operate, and re-tidy", {
  if (require("gapminder", quietly = TRUE)) {
    ret <- gapminder %>%
      widely(cor, year, country, lifeExp)()

    expect_is(ret$item1, "character")
    expect_is(ret$item2, "character")
  }
})
