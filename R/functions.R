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
  raw_data <- clone_shared_raw(name, "raw")
  conn <- rawConnection(raw_data, "r")
  obj <- unserialize(conn)
  close(conn)
  obj
}

#' Clone objects from shared memory to an environment
#' @param ... character values indicating names of objects
#' in shared memory.
#' @param envir an environment to which the cloned objects
#' are exported.
#' @export
clone_objects <- function(..., envir = parent.frame()) {
  args <- vapply(list(...), identity, character(1L))
  arg_names <- names(args)
  empty_names_selector <- !nzchar(arg_names)
  arg_names[empty_names_selector] <- args[empty_names_selector]
  names(args) <- arg_names
  invisible(list2env(lapply(args, clone_object), envir = envir))
}

#' Clone objects in a shared environment
#' @param name character. name of the shared environment.
#' @param envir an environment to which the objects in the
#' shared environment are exported.
#' @export
clone_environment <- function(name, envir = parent.frame()) {
  invisible(list2env(clone_object(name), envir))
}

#' Share an object to shared memory
#' @param x an object.
#' @param name character. The name of the object.
#' @param overwrite a logical to indicate whether to overwrite
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
  share_raw(rawConnectionValue(conn), name, "raw", overwrite)
  close(conn)
  invisible()
}

#' Share objects to shared memory
#' @param ... objects to share. Unnamed arguments must be given as
#'  a symbol rather than an expression.
#' @export
share_objects <- function(...) {
  args <- match.call(expand.dots = FALSE)$...
  objs <- list(...)
  arg_names <- names(objs)
  if (is.null(arg_names)) arg_names <- character(length(objs))
  empty_names_selector <- !nzchar(arg_names)
  arg_names[empty_names_selector] <- vapply(args[empty_names_selector],
    function(arg) {
      if (is.symbol(arg)) as.character(arg)
      else stop("Unnamed argument must be a symbol rather than an expression", call. = FALSE)
    }, character(1L))
  res <- .mapply(share_object, list(objs, arg_names), NULL)
  invisible()
}

#' Share the objects of an environment to shared memory
#' @param name character. the name of the shared memory object.
#' @param envir an environment to share. In default, the calling environment
#' will be shared.
#' @param all.names a logical indicating whether to share all values or
#' (default) those whose names do not begin with a dot.
#' @param overwrite a logical to indicate whether to overwrite
#' existing memory with the same name.
#' @export
share_environment <- function(name, envir = parent.frame(),
  all.names = TRUE, overwrite = TRUE) {
  share_object(as.list.environment(envir, all.names = all.names), name, overwrite)
}

#' Remove objects from shared memory
#' @param ... The names of the object.
#' @export
#' @examples
#' \dontrun{
#' unshare("shared_data")
#' }
unshare <- function(...) {
  name <- c(list(...), recursive = TRUE)
  stopifnot(is.character(name))
  invisible(vapply(name, remove_shared_object, integer(1L), USE.NAMES = FALSE) == 0L)
}

#' Do objects exist in shared memory?
#' @param ... The names of the objects.
#' @export
#' @examples
#' \dontrun{
#' sharing("obj1")
#' }
sharing <- function(...) {
  name <- c(list(...), recursive = TRUE)
  stopifnot(is.character(name))
  vapply(name, exists_shared_object, integer(1L), USE.NAMES = FALSE) == 0L
}
