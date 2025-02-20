# The script platform.pl requires the command 'which' to be installed in the system
yum install -y which 

# Download swash installer
wget https://swash.sourceforge.io/download/zip/swash-11.01.tar.gz
tar xzvf swash-11.01.tar.gz
cd swash-11.01
make config
make ser
cp swash.exe ../swash_serial.exe
make clean
make  mpi
cp swash.exe ../swash_mpi.exe




