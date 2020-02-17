## Install rFVS
```r
install_github(
  "SilviaTerra/rFVS",
  ref = "make_package"
)
```

## FVS Configuration

To install download, install, and configure FVS you can run `install_fvs.sh` on a linux machine.

```r
system(paste("sh", system.file("install_fvs.sh", package = "rFVS")))
```

This script follows guide on the open FVS [wiki](https://sourceforge.net/p/open-fvs/wiki/BuildProcess_UnixAlike/) for installing dependencies and configuring FVS.
