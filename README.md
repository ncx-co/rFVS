## FVS Configuration

following guide on open FVS [wiki](https://sourceforge.net/p/open-fvs/wiki/BuildProcess_UnixAlike/)

install some more dependencies
```bash
sudo apt-get update &&
sudo apt-get install -y --allow-unauthenticated \
  build-essential \
  cmake \
  gfortran \
  libsqliteodbc \
  subversion \
  unixodbc-dev
```

Clone FVS from SVN repository
```bash
svn checkout https://svn.code.sf.net/p/open-fvs/code/trunk/ /opt/open-fvs
```

Build the executables.
```bash
cd /opt/open-fvs/bin
make
```

configure SQLite to play nice with FVS Database Extension by adding another few lines to end
it is unclear if this actually helps...
```bash
sudo chmod 777 /etc/odbcinst.ini
nano /etc/odbcinst.ini
```

```diff
+[SQLite3 ODBC Driver]
+Description=SQLite3 ODBC Driver
+Driver=libsqlite3odbc.so
+Setup=libsqlite3odbc.so
+UsageCount=1
```
