context("cast_dual")

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(gapminder))

test_that("cast_dual works on gapminder data", {
  cast_tbl <- gapminder %>%
    select(country, continent, year, lifeExp) %>%
    cast_dual(country, year, lifeExp, sparse = FALSE)

  # one row per item in the table
  expect_is(cast_tbl$tbl$country, "factor")
  expect_equal(nrow(cast_tbl$tbl), length(unique(gapminder$country)))

  # one row per item in the matrix as well
  expect_equal(nrow(cast_tbl$tbl), nrow(cast_tbl$matrix))
  expect_equal(as.character(cast_tbl$tbl$country), rownames(cast_tbl$matrix))

  # one column per feature
  expect_equal(ncol(cast_tbl$matrix), length(unique(gapminder$year)))
})


test_that("cast_dual can create a sparse matrix", {
  ret <- mtcars %>%
    cast_dual(hp, cyl, mpg)

  expect_is(ret$matrix, "sparseMatrix")
  expect_equal(dim(ret$matrix), c(length(unique(mtcars$hp)), 3))
})
