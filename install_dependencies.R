# allow files to be compiled in parallel (8 cores)
Sys.setenv("MAKE" = "make -j 8")

# List of ST R packages we want in sequoia
packages_to_install <- c(
  "RSQLite",
  "rhandsontable",
  "digest",
  "colourpicker",
  "rgl",
  "leaflet",
  "openxlsx"
)

for (package in packages_to_install) {
  install.packages(package, quiet = F, repos = "http://cran.cnr.berkeley.edu")
  stopifnot(package %in% installed.packages()[,'Package'])
}
