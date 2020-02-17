#' @title Add Trees
#' @description Add new tree records to an existing simulation. Designed to be 
#' used to simulate regeneration establishment.
#'
#' @param newtrees A dataframe that has values defined for the following 
#' attributes of new trees:
#' `dbh`: Diameter breast height (inches)
#' `species`: FVS numeric species code
#' `ht`: Height (feet)
#' `cratio`: Crown ratio (proportion of height in live crown
#' `plot`: FVS numeric plot index
#' `tpa`: Trees per acre
#'
#' @return A scalar integer with the return code from FVS where 0 signals trees 
#' were added and 1 signals an error.
#' @export

fvsAddTrees <- function(newtrees) {
  if (missing(newtrees)) {
    stop("newtrees must be specified.")
  }
  
  cns <- colnames(newtrees)
  
  if (is.null(cns)) {
    stop("newtrees must have colnames.")
  }
  
  req <- c("dbh", "species", "ht", "cratio", "plot", "tpa")
  
  locrec <- match(req, cns)
  
  if (any(is.na(locrec))) {
    stop(
      paste(
        "absent attributes=",
        paste(req[is.na(locrec)], collapse = ", ")
      )
    )
  }
  
  if (any(is.na(newtrees))) {
    stop("no missing values allowed")
  }
  
  room <- fvsGetDims()
  
  mxsp <- room["maxspecies"]
  plts <- room["nplots"]
  room <- room["maxtrees"] - room["ntrees"]
  ntrees <- as.integer(nrow(newtrees))
  
  if (ntrees > room) {
    stop(paste("room for", room, "and newtrees has", ntrees, "trees"))
  }
  
  in_dbh <- as.numeric(newtrees[, locrec[1]])
  in_species <- as.numeric(newtrees[, locrec[2]])
  
  if (any(in_species == 0)) {
    stop("species codes must be > 0")
  }
  
  if (any(in_species > mxsp)) {
    stop("some (all) species codes must be within range for this FVS.")
  }
  
  in_ht <- as.numeric(newtrees[, locrec[3]])
  in_cratio <- as.numeric(newtrees[, locrec[4]])
  in_plot <- as.numeric(newtrees[, locrec[5]])
  
  if (any(in_plot == 0)) {
    stop("plot codes must be > 0")
  }
  
  if (any(in_plot > plts)) {
    stop("plot codes must be within range for this run.")
  }
  in_tpa <- as.numeric(newtrees[, locrec[6]])
  rtn <- .Fortran(
    "fvsAddTrees", in_dbh, in_species, in_ht, in_cratio,
    in_plot, in_tpa, ntrees, as.integer(0)
  )
  
  invisible(rtn[[8]])
}
