# The script platform.pl requires the command 'which' to be installed in the system
yum install -y which 

# Download swash installer
wget https://swanmodel.sourceforge.io/download/zip/swan4151.tar.gz
tar xzvf swan4151.tar.gz
cd swan4151
make config
make ser
cp swash.exe swash_serial.exe
make clean
make  mpi
cp swash.exe swash_mpi.exe
make clean
make omp
cp swash.exe swash_omp.exe