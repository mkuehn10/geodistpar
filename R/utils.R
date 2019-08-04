#' find_xy_cols
#'
#' Find the lon and lat cols of a rectangular object
#' @param obj Rectangular object
#' @return Vector of two column indices of longitude and latitude
#' @noRd
find_xy_cols <- function (obj)
{
  nms <- names (obj)
  if (is.null (nms))
    nms <- colnames (obj)

  if (!is.null (nms))
  {
    ix <- grep ("x|lon", nms, ignore.case = TRUE)
    if (length (ix) > 1)
    {
      ix <- grep ("^x|lon", nms, ignore.case = TRUE)
      if (length (ix) != 1)
      {
        ix <- grep ("x$|lon", nms, ignore.case = TRUE)
        if (length (ix) != 1)
          ix <- grep ("^x$|lon", nms, ignore.case = TRUE)
      }
    }
    iy <- grep ("y|lat", nms, ignore.case = TRUE)
    if (length (iy) > 1)
    {
      iy <- grep ("^y|lat", nms, ignore.case = TRUE)
      if (length (iy != 1))
      {
        iy <- grep ("y$|lat", nms, ignore.case = TRUE)
        if (length (iy) != 1)
          iy <- grep ("^y$|lat", nms, ignore.case = TRUE)
      }
    }
    if (length (ix) != 1 | length (iy) != 1)
      stop ("Unable to determine longitude and latitude columns; ",
            "perhaps try re-naming columns.")
  } else
  {
    message ("object has no named columns; assuming order is lon then lat")
    ix <- 1
    iy <- 2
  }
  c (ix, iy)
}

#' convert_to_matrix
#'
#' Convert a rectangular object to a matrix of two columns, lon and lat
#'
#' @param obj Rectagular object
#' @return Numeric matrix of two columns: lon and lat
#' @noRd
convert_to_matrix <- function (obj)
{
  xy_cols <- find_xy_cols (obj)
  if (is.vector (obj))
    obj <- matrix (obj, nrow = 1)
  if (is.numeric (obj))
    cbind (as.numeric (obj [, xy_cols [1]]),
           as.numeric (obj [, xy_cols [2]]))
  else
    cbind (as.numeric (obj [[xy_cols [1] ]]),
           as.numeric (obj [[xy_cols [2] ]]))
}
