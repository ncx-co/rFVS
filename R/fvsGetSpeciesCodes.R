#' @title Get Species Codes
#'
#' @return A matrix of character strings with one row for each species and three
#'   columns. The column names fvs, fia, plant correspond to the three kinds of 
#'   species codes used in FVS. The order is exactly as presented in the FVS 
#'   variant which means, for example, that row 1 corresponds to the internal 
#'   FVS species index number 1, row 2 for species 2 and so on.
#' @export

fvsGetSpeciesCodes <- function() {
  maxsp <- fvsGetDims()["maxspecies"]

  all <- NULL
  for (i in 1:maxsp) {
    ans <- .Fortran(
      "fvsSpeciesCode", strrep(" ", 10), strrep(" ", 10), strrep(" ", 10),
      as.integer(i), as.integer(0), as.integer(0), as.integer(0),
      as.integer(0)
    )
    ans <- c(
      substr(ans[[1]], 1, ans[[5]]), substr(ans[[2]], 1, ans[[6]]),
      substr(ans[[3]], 1, ans[[7]])
    )
    all <- if (is.null(all)) ans else rbind(all, ans)
  }
  rownames(all) <- 1:maxsp
  colnames(all) <- c("fvs", "fia", "plant")
  all
}
