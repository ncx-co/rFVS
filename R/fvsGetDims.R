#' @title Get dims
#'
#' @return A named vector of integers as follows: 
#'   `ntrees`, `ncycles`, `nplots`, `maxtrees`, `maxspecies`, `maxplots`, 
#'   `maxcycles`
#' @export

fvsGetDims <- function() {
  fvsDims <- unlist(
    .Fortran(
      "fvsDimSizes", as.integer(0), as.integer(0),
      as.integer(0), as.integer(0), as.integer(0), as.integer(0), as.integer(0)
    )
  )
  names(fvsDims) <- c(
    "ntrees", "ncycles", "nplots", "maxtrees", "maxspecies",
    "maxplots", "maxcycles"
  )
  fvsDims
}
