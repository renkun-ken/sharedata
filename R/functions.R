#' @useDynLib sharedata
#' @importFrom Rcpp sourceCpp
NULL

#' @export
getSharedVector <- function(segment, name) {
  get_shared_int(segment, name)
}

#' @export
shareVector <- function(x, segment, name) {
  share_int(segment, name)
}
