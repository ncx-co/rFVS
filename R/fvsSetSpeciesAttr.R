#' @title Set Species Attrs
#'
#' @param vars A named list of vectors (or a dataframe) where each vector (or 
#'   column) is: of numeric type, has no NAs, has as many entries as there are 
#'   defined species (variable maxspecies from fvsGetDims()).
#'   Use the variable names listed for fvsGetSpeciesAttrs(vars). Vectors or 
#'   columns that have other names are skipped.
#'
#' @return A scalar integer return code where 0 signals OK and 1 signals an 
#'   error).
#' @export

fvsSetSpeciesAttrs <- function(vars) {
  maxspecies <- fvsGetDims()["maxspecies"]
  action <- "set"
  if (!is.list(vars)) {
    stop("vars must be a list")
  }
  if (is.null(names(vars))) {
    stop("vars must have names")
  }
  rtn <- 0
  for (name in names(vars)) {
    atr <- as.numeric(vars[[name]])
    if (length(atr) != maxspecies) {
      warning("Length of '", name, "' must be ", maxspecies)
      next
    }
    if (any(is.na(atr))) {
      warning("NA(s) found for variable '", name, "'")
      next
    }
    nch <- nchar(name)
    ans <- .Fortran("fvsSpeciesAttr", name, nch, action, atr, as.integer(0))
    if (ans[[5]] != 0) {
      rtn <- if (ans[[5]] > rtn) ans[[5]] else rtn
      warning("error assigning variable '", name, "'")
      next
    }
  }
  invisible(rtn)
}
