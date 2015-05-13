#' @useDynLib sharedata
#' @importFrom Rcpp sourceCpp
NULL

#' Copy object from shared memory
#' @param name character. The name of the object.
#' @export
#' @examples
#' \dontrun{
#' get_object("shared_numbers")
#' }
get_object <- function(name) {
  stopifnot(is.character(name))
  raw_data <- get_shared_raw(name, "raw")
  conn <- rawConnection(raw_data, "r")
  obj <- unserialize(conn)
  close(conn)
  obj
}

#' Copy object to shared memory
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

#' Remove object from shared memory
#' @param name character. The name of the object.
#' @export
#' @examples
#' \dontrun{
#' remove_object("shared_data")
#' }
remove_object <- function(name) {
  stopifnot(is.character(name))
  remove_raw(name) == 0L
}
