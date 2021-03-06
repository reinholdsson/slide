# ------------------------------------------------------------------------------
# pslide_vec

test_that("pslide_vec() works", {
  expect_equivalent(pslide_vec(list(1L, 1L), ~.x + .y), list(2L))
})

test_that("pslide_vec() retains names of first input", {
  expect_equivalent(pslide_vec(list(c(x = 1L), c(y = 1L)), ~.x + .y), list(x = 2L))
})

test_that("pslide_vec() can simplify automatically", {
  expect_equivalent(pslide_vec(list(1, 2), ~.x + .y, .ptype = NULL), 3)
})

test_that("pslide_vec() errors if it can't simplify", {
  fn <- function(x, y) if (x == 1L) {1} else {"hi"}
  expect_error(
    pslide_vec(list(1:2, 1:2), fn, .ptype = NULL),
    class = "vctrs_error_incompatible_type"
  )
})

# ------------------------------------------------------------------------------
# suffix tests

test_that("pslide_int() works", {
  expect_equivalent(pslide_int(list(1L, 1L), ~.x + .y), 2L)
})

test_that("pslide_int() can coerce", {
  expect_equivalent(pslide_int(list(1, 1), ~.x + .y), 2L)
})

test_that("pslide_dbl() works", {
  expect_equivalent(pslide_dbl(list(1, 1), ~.x), 1)
})

test_that("pslide_dbl() can coerce", {
  expect_equivalent(pslide_dbl(list(1L, 1L), ~.x + .y), 2)
})

test_that("pslide_chr() works", {
  expect_equivalent(pslide_chr(list("x", 1), ~.x), "x")
})

test_that("pslide_chr() can coerce", {
  expect_equivalent(pslide_chr(list(1, 1), ~.x + .y), "2")
})

test_that("pslide_lgl() works", {
  expect_equivalent(pslide_lgl(list(TRUE, 1), ~.x), TRUE)
})

test_that("pslide_lgl() can coerce", {
  expect_equivalent(pslide_lgl(list(1, 0), ~.x + .y), TRUE)
})

# ------------------------------------------------------------------------------
# data frame suffix tests

test_that("pslide_dfr() works", {
  expect_equal(
    pslide_dfr(list(1:2, 1:2), ~c(.x, .y), .before = 1),
    data.frame(
      ...1 = c(1, 1),
      ...2 = c(1, 2),
      ...3 = c(NA, 1),
      ...4 = c(NA, 2)
    )
  )

  x <- 1:2
  expect_equal(
    pslide_dfr(list(x, x), ~data.frame(x = .x, y = .y), .before = 1),
    data.frame(x = c(1, 1, 2), y = c(1, 1, 2))
  )
})

test_that("pslide_dfc() works", {
  x <- 1:2
  expect_equal(
    pslide_dfc(list(x, x), ~data.frame(x = .x, y = .y), .before = 1),
    data.frame(
      x...1 = c(1, 1),
      y...2 = c(1, 1),
      x...3 = c(1, 2),
      y...4 = c(1, 2)
    )
  )
})
