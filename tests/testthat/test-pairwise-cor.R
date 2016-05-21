context("pairwise_cor")

suppressPackageStartupMessages(library(dplyr))

d <- data_frame(col = rep(c("a", "b", "c"), each = 3),
                row = rep(c("d", "e", "f"), 3),
                value = c(1, 2, 3, 6, 5, 4, 7, 9, 8))

test_that("pairwise_cor computes pairwise correlations", {
  ret <- d %>%
    pairwise_cor(col, row, value)

  ret1 <- ret$correlation[ret$item1 == "a" & ret$item2 == "b"]
  expect_equal(ret1, cor(1:3, 6:4))

  ret2 <- ret$correlation[ret$item1 == "b" & ret$item2 == "c"]
  expect_equal(ret2, cor(6:4, c(7, 9, 8)))

  expect_equal(sum(ret$item1 == ret$item2), 0)
})

test_that("pairwise_cor can compute Spearman correlations", {
  ret <- d %>%
    pairwise_cor(col, row, value, method = "spearman")

  ret1 <- ret$correlation[ret$item1 == "a" & ret$item2 == "b"]
  expect_equal(ret1, -1)
})