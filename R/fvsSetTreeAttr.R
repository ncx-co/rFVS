#' @title Set Tree Attrs
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

fvsSetTreeAttrs <- function(vars) {
  ntrees <- fvsGetDims()["ntrees"]
  action <- "set"
  if (!is.list(vars)) stop("vars must be a list")
  if (is.null(names(vars))) stop("vars must have names")
  rtn <- 0
  for (name in names(vars))
  {
    atr <- as.numeric(vars[[name]])
    if (length(atr) != ntrees) {
      warning("Length of '", name, "' must be ", ntrees)
      next
    }
    if (any(is.na(atr))) {
      warning("NA(s) found for variable '", name, "'")
      next
    }
    nch <- nchar(name)
    ans <- .Fortran("fvsTreeAttr", name, nch, action, ntrees, atr, as.integer(0))
    if (ans[[6]] != 0) {
      rtn <- if (ans[[6]] > rtn) ans[[6]] else rtn
      warning("error assigning variable '", name, "'")
      next
    }
  }
  invisible(rtn)
}
