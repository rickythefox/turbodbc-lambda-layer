#!/bin/bash

# Create unixODBC config files
cat <<EOF > /out/odbcinst.ini
[ODBC Driver 17 for SQL Server]
Description=Microsoft ODBC Driver 17 for SQL Server
Driver=/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.7.so.2.1
UsageCount=1
EOF
cat <<EOF > /out/odbc.ini
[ODBC Driver 17 for SQL Server]
Driver = ODBC Driver 17 for SQL Server
Description = My ODBC Driver 17 for SQL Server
Trace = No
EOF

# Download and build unixODBC
unixODBCVersion=2.3.11
cd /work
curl -O ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-$unixODBCVersion.tar.gz
tar xzvf unixODBC-$unixODBCVersion.tar.gz
cd unixODBC-$unixODBCVersion
./configure --sysconfdir=/opt --disable-gui --disable-drivers --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE --prefix=/opt
make 
make install 

# Copy build result to /usr
cp -r /opt/* /usr

# Download and build boost
boostVersion=1.82.0
boostVersionSnakeCase=${boostVersion//./_}
cd /work
curl -L https://boostorg.jfrog.io/artifactory/main/release/$boostVersion/source/boost_$boostVersionSnakeCase.tar.bz2 > boost.tar.bz2
tar jxf boost.tar.bz2
cd boost_$boostVersionSnakeCase
./bootstrap.sh --prefix=/usr/local
./b2 install --with-date_time --with-locale

# Install turbodbc
pip install turbodbc -t /out/python/lib/python3.10/site-packages

# Copy required parts of unixODBC to output
cp -r /opt/microsoft /out
cp -r /opt/lib /out

# Zip the layer
cd /out
zip -r9 turbodbc-layer.zip .

echo "Lambda layer created!"
