#' @useDynLib sharedata
#' @importFrom Rcpp sourceCpp
NULL

#' @export
getSharedVector <- function(segment, name, mode) {
  do.call(sprintf("get_shared_%s_vector", mode), list(segment, name))
}

#' @export
shareVector <- function(x, segment, name)
  UseMethod("shareVector")

#' @export
shareVector.integer <- function(x, segment, name) {
  share_integer_vector(x, segment, name)
}

#' @export
shareVector.numeric <- function(x, segment, name) {
  share_numeric_vector(x, segment, name)
}
