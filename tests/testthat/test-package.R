context("sharedata")

test_that("share", {
  share_object(1:10, "data1")
  share_object(letters, "data2")
  share_object(mtcars, "data3")
  share_objects(data4 = letters, data5 = mtcars)
  share_environment("env1", list2env(list(a=letters, b=mtcars)))
  local({
    a <- letters
    b <- mtcars
    share_environment("env2")
  })
})

test_that("sharing", {
  expect_equal(sharing("data1"), TRUE)
  expect_equal(sharing(c("data2", "data3")), c(TRUE, TRUE))
  expect_equal(sharing(c("data4", "data5", "data-not-exists")), c(TRUE, TRUE, FALSE))
})

test_that("clone", {
  expect_identical(clone_object("data1"), 1:10)
  expect_identical(clone_object("data1", NULL), 1:10)
  expect_identical(clone_object("data2"), letters)
  expect_identical(clone_object("data3"), mtcars)
  expect_error(clone_object("non_existing_data"))
  expect_identical(clone_object("non_existing_data", NULL), NULL)
  expect_identical(clone_object("non_existing_data", 1:10), 1:10)
  expect_identical({
    e <- new.env()
    clone_objects(p = "data4", q = "data5", envir = e)
    list(e$p, e$q)
  }, list(letters, mtcars))
  expect_identical({
    e <- new.env()
    clone_environment("env1", envir = e)
    list(e$a, e$b)
  }, list(letters, mtcars))
  expect_identical(local({
    clone_environment("env2")
    list(a, b)
  }), list(letters, mtcars))
})

test_that("unshare", {
  unshare("data1")
  unshare("data2")
  unshare("data3")
  unshare(c("data4", "data5", "env1", "env2"))
})
