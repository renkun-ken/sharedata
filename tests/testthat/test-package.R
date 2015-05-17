context("sharedata")

test_that("share_object", {
  share_object(1:10, "data1")
  share_object(letters, "data2")
  share_object(mtcars, "data3")
})

test_that("get_object", {
  expect_identical(clone_object("data1"), 1:10)
  expect_identical(clone_object("data2"), letters)
  expect_identical(clone_object("data3"), mtcars)
})

test_that("remove_object", {
  remove_object("data1")
  remove_object("data2")
  remove_object("data3")
})
