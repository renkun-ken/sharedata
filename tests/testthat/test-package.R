context("sharedata")

test_that("share_object", {
  expect_equal(share_object(1:10, "data1"), TRUE)
  expect_equal(share_object(letters, "data2"), TRUE)
  expect_equal(share_object(mtcars, "data3"), TRUE)
})

test_that("get_object", {
  expect_identical(clone_object("data1"), 1:10)
  expect_identical(clone_object("data2"), letters)
  expect_identical(clone_object("data3"), mtcars)
})

test_that("remove_object", {
  expect_equal(remove_object("data1"), TRUE)
  expect_equal(remove_object("data2"), TRUE)
  expect_equal(remove_object("data3"), TRUE)
})
