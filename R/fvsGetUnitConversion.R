#' @title Unit Conversion
#'
#' @param name A case sensitive character string naming a conversion factor to 
#'   be returned. See Return Unit Conversions for a list of valid codes.
#'
#' @return A scalar numeric value; NA if the name is not valid.
#' @export

fvsUnitConversion <- function(name) {
  nch <- nchar(name)
  ans <- .Fortran(
    "fvsUnitConversion", name, nch, as.numeric(0), as.integer(0)
  )
  if (ans[[4]] == 0) {
    return(ans[[3]])
  } else {
    return(NA)
  }
}
