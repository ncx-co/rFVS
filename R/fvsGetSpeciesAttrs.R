#' @title Get Species Attributes
#'
#' @param vars A vector of strings whereby each string names an attribute to be 
#'   returned. The names can be one or more of the following:
#'   `spccf`: CCF for each species, recomputed in FVS so setting will likely have 
#'   no effect
#'   `spsdi`: SDI maximums for each species
#'   `spsiteindx`: Species site indices
#' @return A dataframe of numeric values with one row for each species and a 
#'   column for each attribute.
#' @export

fvsGetSpeciesAttrs <- function(vars) {
  maxspecies <- fvsGetDims()["maxspecies"]
  atr <- vector("numeric", maxspecies)
  action <- "get"
  all <- list()
  for (name in vars)
  {
    nch <- nchar(name)
    ans <- .Fortran("fvsSpeciesAttr", name, nch, action, atr, as.integer(0))
    if (ans[[5]] == 0) all[[name]] <- ans[[4]]
  }
  as.data.frame(all)
}
