#' @useDynLib geodistpar
#' @importFrom Rcpp sourceCpp
NULL

#' geodistpar
#'
#' Generate a distance matrix
#'
#' @param x Rectangular object
#' @param y Rectangular object
#' @export
geodistpar <- function(x, y, measure = "cheap") {

  measures <- c("haversine", "vincenty", "cheap", "geodesic")
  measure <- match.arg(tolower(measure), measures)
  measure = which(measure == measures)

  x <- convert_to_matrix(x)

  if (!missing(y)) {
    y <- convert_to_matrix(y)
    geodistpar_cpp(x, y, measure)
  } else {
    geodistpar_cpp(x, x, measure)
  }


}
