#!/bin/bash
sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial-cran35/" >> \
    /etc/apt/sources.list'
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
apt-get update &&
apt-get install -y --allow-unauthenticated \
  subversion \
  gfortran \
  cmake \
  unixodbc-dev \
  build-essential

svn checkout https://svn.code.sf.net/p/open-fvs/code/trunk/ /opt/open-fvs
cd /opt/open-fvs/bin
make

cat >>/etc/odbcinst.ini <<EOF
[SQLite3 ODBC Driver]
Description=SQLite3 ODBC Driver
Driver=libsqlite3odbc.so
Setup=libsqlite3odbc.so
UsageCount=1
EOF
