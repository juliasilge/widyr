context("widely")

test_that("widely can widen, operate, and re-tidy", {
  if (require("gapminder", quietly = TRUE)) {
    ret <- gapminder %>%
      widely(cor)(year, country, lifeExp)

    expect_is(ret$item1, "character")
    expect_is(ret$item2, "character")

    expect_true(all(c("Afghanistan", "United States") %in% ret$item1))
    expect_true(all(c("Afghanistan", "United States") %in% ret$item2))
    expect_true(all(ret$value <= 1))
    expect_true(all(ret$value >= -1))

    expect_equal(nrow(ret), length(unique(gapminder$country)) ^ 2)

    ret2 <- gapminder %>%
      widely(cor, sort = TRUE)(year, country, lifeExp)

    expect_equal(sort(ret$value, decreasing = TRUE), ret2$value)
  }
})

test_that("widely's maximum size argument works", {
  f <- function() {
    widely(cor, maximum_size = 1000)(gapminder, year, country, lifeExp)
  }
  expect_error(f(), "1704.*large")
})
