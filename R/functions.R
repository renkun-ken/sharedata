#' @useDynLib sharedata
#' @importFrom Rcpp sourceCpp
NULL

#' Clone an object from shared memory
#' @param name character. The name of the object.
#' @export
#' @examples
#' \dontrun{
#' clone_object("shared_numbers")
#' }
clone_object <- function(name) {
  stopifnot(is.character(name))
  raw_data <- get_shared_raw(name, "raw")
  conn <- rawConnection(raw_data, "r")
  obj <- unserialize(conn)
  close(conn)
  obj
}

#' @export
clone_objects <- function(..., envir = parent.frame()) {
  args <- list(...)
  if (is.null(obj_names <- names(args)) || !all(nzchar(obj_names))) {
    stop("All arguments must be named")
  }
  .mapply(function(var, name) {
    assign(var, clone_object(name), envir = envir)
  }, list(obj_names, args), NULL)
  invisible(NULL)
}

#' @export
clone_environment <- function(name, envir = parent.frame()) {
  invisible(list2env(clone_object(name), envir))
}

#' Share an object to shared memory
#' @param x an object.
#' @param name character. The name of the object.
#' @param overwrite logical to indicate whether to overwrite
#' existing memory with the same name.
#' @export
#' @examples
#' \dontrun{
#' share_object(mtcars, "shared_mtcars")
#' share_object(rnorm(1000), "shared_rnd_numbers")
#' }
share_object <- function(x, name, overwrite = TRUE) {
  stopifnot(is.character(name), is.logical(overwrite))
  conn <- rawConnection(raw(0L), "w")
  serialize(x, conn)
  seek(conn, 0L)
  res <- share_raw(rawConnectionValue(conn), name, "raw", overwrite)
  close(conn)
  res == 0L
}

#' @export
share_objects <- function(...) {
  args <- list(...)
  if (is.null(obj_names <- names(args)) || !all(nzchar(obj_names))) {
    stop("All arguments must be named")
  }
  res <- .mapply(share_object, list(args, obj_names), NULL)
  invisible(vapply(res, identical, logical(1L), 0L))
}

#' @export
share_environment <- function(name, envir = parent.frame(),
  all.names = FALSE, overwrite = TRUE) {
  share_object(as.list.environment(envir, all.names = all.names), name, overwrite)
}

#' Remove object from shared memory
#' @param name character. The name of the object.
#' @export
#' @examples
#' \dontrun{
#' remove_object("shared_data")
#' }
remove_object <- function(name) {
  stopifnot(is.character(name))
  invisible(vapply(name, remove_raw, integer(1L)) == 0L)
}
