#' @title run FVS program
#' @description Run FVS program
#'
#' @param stopPointCode The value of the next stop point, see Stop Points for a
#'   list of valid codes.
#' @param stopPointYear The simulation year the stop point is requested. Code -1
#'   to signal the that the stop point should be immediate.
#' @return A return code from FVS, see Return code state. If the return code is
#'   zero, then it is often very useful to use fvsGetRestartcode() to fetch the
#'   restart code that resulted in FVS returning. When fvsRun() is called again,
#'   it will continue processing where it left off. Repeating the call to
#'   fvsRun() until it is non-zero is how to create a simple simulation.
#' @export

fvsRun <- function(stopPointCode = NA, stopPointYear = NA, PACKAGE) {
  if (!is.na(stopPointCode) & !is.na(stopPointCode)) {
    .Fortran(
      "fvsSetStoppointCodes", as.integer(stopPointCode),
      as.integer(stopPointYear),
      PACKAGE = PACKAGE
    )
  }

  repeat  {
    rtn <- .Fortran("fvs", as.integer(0)) [[1]]
    if (rtn != 0) break
    stopPoint <- .Fortran("fvsGetRestartCode", as.integer(0), PACKAGE = PACKAGE)[[1]]
    if (stopPoint != 0) break
  }
  invisible(rtn)
}
