#' @useDynLib sharedata
#' @importFrom Rcpp sourceCpp
NULL

#' @export
get_object <- function(name) {
  stopifnot(is.character(name))
  raw_data <- get_shared_raw(name, "raw")
  conn <- rawConnection(raw_data, "r")
  obj <- unserialize(conn)
  close(conn)
  obj
}

#' @export
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
remove_object <- function(name) {
  stopifnot(is.character(name))
  remove_raw(name) == 0L
}
