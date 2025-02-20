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

source /opt/intel/oneapi/setvars.sh
