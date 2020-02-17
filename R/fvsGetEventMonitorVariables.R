#' @title Get Event Monitor Variables
#'
#' @param vars A scalar or vector of strings whereby each string names an FVS 
#'   Event Monitor for which the value will be returned.
#'
#' @return A named vector of values. The values will be NA if they were not 
#'   defined.
#' @export

fvsGetEventMonitorVariables <- function(vars) {
  if (missing(vars)) {
    stop("vars must be present")
  }
  if (class(vars) != "character") {
    stop("vars must be type character")
  }
  atr <- vector("numeric", length(vars))
  all <- NULL
  for (name in vars) {
    nch <- as.integer(nchar(name))
    ans <- .Fortran(
      "fvsEvmonAttr", tolower(name), nch, "get",
      as.double(0), as.integer(0)
    )
    all <- c(all, if (ans[[5]] == 0) ans[[4]] else NA)
  }
  names(all) <- vars
  all
}

#' @title Set Event Monitor Variables
#' @description This function sets the values of Event Monitor variables. 
#'   Generally, however, many of the variables are reset to by FVS when the 
#'   Event Monitor is called each cycle (before and after simulated harvests). 
#'   This is especially true of those automatic variables defined during the 
#'   first and second calls to the Event Monitor (consult FVS documentation). 
#'   Therefore setting the value of these variables may be in effective in 
#'   meeting useful goals. 
#'   
#'   One use of this function is to set user-defined variables (those 
#'   traditionally defined using the FVS Compute keyword). If a Event Monitor 
#'   variable that has the name given in the names attribute of the vars 
#'   argument is not found, one is created. If a user-defined variable has 
#'   already been defined, it is given a new value when this function is called.
#'
#' @param vars A vector of named numeric values where the names are FVS Event 
#'   Monitor variable names that will take on the corresponding values.
#'
#' @return A named vector of values. The values will be NA if they were not 
#'   defined.
#' @export

fvsSetEventMonitorVariables <- function(vars) {
  if (missing(vars)) {
    stop("vars must be present")
  }
  if (class(vars) != "numeric") {
    stop("vars must be type numeric")
  }
  if (is.null(names(vars))) {
    stop("vars must be named")
  }
  atr <- vector("numeric", length(vars))
  all <- NULL
  for (name in names(vars)) {
    nch <- as.integer(nchar(name))
    ans <- .Fortran(
      "fvsEvmonAttr", tolower(name), nch, "set",
      as.double(vars[name]), as.integer(0)
    )
    all <- c(all, if (ans[[5]] == 0) ans[[4]] else NA)
  }
  names(all) <- names(vars)
  all
}
