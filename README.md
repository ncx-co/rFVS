## FVS Configuration

## On Instance
Install subversion
```bash
sudo apt-get update
sudo apt-get install -y --allow-unauthenticated subversion
```

Clone FVS from SVN repository
```bash
svn checkout https://svn.code.sf.net/p/open-fvs/code/trunk/ /opt/open-fvs
```

following https://sourceforge.net/p/open-fvs/wiki/BuildProcess_UnixAlike/...

install some more dependencies
```bash
sudo apt-get install -y --allow-unauthenticated \
  gfortran \
  cmake \
  unixodbc-dev \
  build-essential \
  libsqliteodbc \
  unixodbc
```

build the executables.
if we run `make FVSsn` the database extension won't work properly, so we will build qFVSsn which will work
```bash
cd /opt/open-fvs/bin
make qFVSsn
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
