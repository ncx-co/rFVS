#' @title Load FVS program
#' @description Sets the command line to the values listed of the FVS Command
#'   Line and opens files for input as indicted by the values found. This
#'   routine can result in the FVS return code state to be reset.
#'
#' @param cl A character string that contains the command line arguments. If
#'   `NULL` (the default), the function attempts to fetch the arguments as
#'   they may be specified on the command that starts R. This is done by
#'   calling the R function `commandArgs(trailingOnly = TRUE)`, see R
#'   documentation for details.
#' @export

fvsSetCmdLine <- function(cl = NULL) {
  if (is.null(cl)) {
    cl <- paste(commandArgs(trailingOnly = TRUE), collapse = " ")
  }
  
  nch <- as.integer(nchar(cl))
  
  invisible(
    if (nch > 0) {
      .Fortran("fvsSetCmdLine", cl, nch, as.integer(0))
    } else {
      NULL
    }
  )
}
