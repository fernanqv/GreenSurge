wget https://swash.sourceforge.io/download/zip/testcases.tar.gz 
tar xzvf testcases.tar.gz 

cd testcases/a11stwav/ 
cp a11stw01.sws INPUT 

echo "Testing SWASH SERIAL"
swash.exe 
cat PRINT
 
echo "TESTING SWASH MPI"
mpirun -np 8 swash_mpi.exe 
cat PRINT

 