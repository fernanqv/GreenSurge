# Create repo file
tee > /tmp/oneAPI.repo << EOF
[oneAPI]
name=Intel® oneAPI repository
baseurl=https://yum.repos.intel.com/oneapi
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
EOF

mv /tmp/oneAPI.repo /etc/yum.repos.d

# Install Intel oneapi compilers, mkl and mpi
dnf install -y intel-oneapi-compiler-dpcpp-cpp 
dnf install -y intel-oneapi-compiler-fortran
dnf install -y intel-oneapi-mkl # TODO. Check if it is necessary
dnf install -y intel-oneapi-mpi

# Last versions of Intel compiler have different names
# Create links to the old names
ln -s /opt/intel/oneapi/compiler/2025.0/bin/ifx /opt/intel/oneapi/compiler/2025.0/bin/ifort
ln -s /opt/intel/oneapi/compiler/2025.0/bin/icx /opt/intel/oneapi/compiler/2025.0/bin/icc
ln -s /opt/intel/oneapi/mpi/2021.14/bin/mpiifx /opt/intel/oneapi/mpi/2021.14/bin/mpiifort

source /opt/intel/oneapi/setvars.sh
