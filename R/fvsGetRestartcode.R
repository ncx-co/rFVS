#' @title Get Restart Code
#' @description Provides an R interface to Fortran function fvsGetRestartcode.
#'
#' @return The FVS restart codes (integer).
#' @export

fvsGetRestartcode <- function() {
  .Fortran("fvsGetRestartCode", as.integer(0))[[1]]
}
