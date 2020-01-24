#' @title Get Tree Attrs
#'
#' @param vars A vector of strings whereby each string names an attribute to be 
#'   returned. The names can be one or more of the following:
#'   
#'   see https://sourceforge.net/p/open-fvs/wiki/rFVS/#fvsgettreeattrsvars
#'
#' @return A dataframe of numeric values with one row for each tree and a column 
#'   for each attribute.
#'   
#'   The defect value is an 8-digit code comprised of four 2-digit code segments 
#'   strung together. Each 2-digit segment represents a different defect, as 
#'   described below.
#'   
#'   first and second digits: input merchantable cubic volume defect percent
#'   third and fourth digits: input board foot defect percent
#'   fifth and sixth digits: applied merchantable cubic volume defect percent
#'   seventh and eighth digits: applied board foot defect percent
#' @export

fvsGetTreeAttrs <- function(vars) {
  ntrees <- fvsGetDims()["ntrees"]
  atr <- vector("numeric", ntrees)
  action <- "get"
  all <- NULL
  for (name in vars) {
    nch <- nchar(name)
    ans <- .Fortran(
      "fvsTreeAttr", name, nch, action, ntrees, atr, as.integer(0)
    )
    if (ans[[6]] == 0) {
      all <- append(all, list(ans[[5]]))
      names(all)[length(all)] <- name
    }
  }
  as.data.frame(all)
}
