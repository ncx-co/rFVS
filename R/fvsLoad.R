#' @title Load FVS program
#' @description Load FVS program
#'
#' @param fvsProgram Name of executable file for FVS variant.
#' @param bin File path to the directory containing FVS executables.
#' @export

fvsLoad <- function(fvsProgram, bin) {
  if (missing(fvsProgram)) {
    stop("fvsProgram is required.")
  }
  
  if (missing(bin)) {
    stop("path to bin is required.")
  }
  
  # strip program suffix if it is present
  fvsProgram <- strsplit(fvsProgram, ".", fixed = TRUE)[[1]][1]
  
  # add the suffix that is consistent for the platform
  fvsProgram <- paste(fvsProgram, .Platform$dynlib.ext, sep = "")
  
  # if the last char of the bin is not a file separator, add one.
  if (substring(bin, nchar(bin)) != .Platform$file.sep) {
    bin <- paste(bin, .Platform$file.sep, sep = "")
  }

  loaded <- vector("list")
  file <- paste(bin, fvsProgram, sep = "")
  
  if (file.exists(file)) {
    if (exists(".FVSLOADEDLIBRARY", envir = .GlobalEnv)) {
      loaded <- get(".FVSLOADEDLIBRARY", envir = .GlobalEnv)
      remove(".FVSLOADEDLIBRARY", envir = .GlobalEnv)
      lapply(loaded, dyn.unload)
    }
    # # if on windows, we also need the sql dll.
    # if (.Platform$OS.type == "windows")
    # {
    #   sql = paste(bin,"libfvsSQL.dll",sep="")
    #   load = dyn.load(sql)[[3]]
    #   if (! load) stop (paste (sql,"was not loaded."))
    #   loaded$sql = sql
    # }
    load <- dyn.load(file)[[3]]
    if (!load) {
      stop(paste(file, "was not loaded."))
    }
    loaded$pgm <- file
    assign(".FVSLOADEDLIBRARY", loaded, envir = .GlobalEnv)
  }
  invisible(loaded)
}
