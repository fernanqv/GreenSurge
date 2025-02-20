# Download and install delft3dfm RPM
wget http://personales.unican.es/fernanqv/delft3dfm-cli-hmwq_lnx64-2024.03-193.x86_64.rpm
rpm -iv --force delft3dfm-cli-hmwq_lnx64-2024.03-193.x86_64.rpm

# Download examples and test Delft3dfm works
wget personales.unican.es/fernanqv/delft3dfm_examples.tar.gz
tar xzvf delft3dfm_examples.tar.gz
cd deltares
../Launch_Delft3d.sh
