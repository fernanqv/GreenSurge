#! /bin/bash

# Display usage if no arguments are provided
usage() {
    echo "Usage: $0 --case_dir <folder> --local-np <number_of_processes>"
    exit 1
}

# Default variables
case_dir=""
np=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --case_dir)
            case_dir="$2"
            shift 2
            ;;
        --local-np)
            np="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1"
            usage
            ;;
    esac
done

# Ensure required arguments are provided
if [[ -z "$case_dir" || -z "$np" ]]; then
    echo "Error: Missing one or more required arguments."
    usage
fi

# Verify that the directory exists
if [[ ! -d "$case_dir" ]]; then
    echo "Error: Directory '$case_dir' does not exist."
    exit 1
fi

# Verify that np is a positive integer
if ! [[ "$np" =~ ^[0-9]+$ ]]; then
    echo "Error: The number of processes (--np) must be a positive integer."
    exit 1
fi

# Display the provided values
echo "Case directory: $case_dir"
echo "Number of processes: $np"

# Add your logic here to handle the case and processes
echo "Running with $np processes in directory $case_dir..."




input_folder=$1
#input_folder=/software/geocean/conda/envs/Delf3Dpruebas/ejemplos/miri1/input

Delft3d_path=/software/geocean/Delft3D/2024.03/
PATH=$PATH:$Delft3d_path/IntelMPI/mpi/latest/bin:$Delft3d_path/opt/delft3dfm_2024.03/lnx64/bin


#I_MPI_ROOT=/software/geocean/Delft3D/2024.03/IntelMPI/mpi/2021.9.0
#I_MPI_MPIRUN=mpirun
#I_MPI_HYDRA_TOPOLIB=hwloc
#I_MPI_HYDRA_BOOTSTRAP=slurm
#I_MPI_DEBUG=5
#I_MPI_PMI_LIBRARY=/usr/lib64/slurm/mpi_pmi2.so
##########################
######   NO TOCAR   ######
##########################

np=$SLURM_CPUS_ON_NODE
echo "SLURM_CPUS_ON_NODE: $np"
# Specify the folder containing your model's MDU file.
mdufileFolder=$input_folder
 
# Specify the folder containing your DIMR configuration file.
dimrconfigFolder=$input_folder

 # The name of the DIMR configuration file. The default name is dimr_config.xml. This file must already exist!
dimrFile=dimr_config.xml
 
# This setting might help to prevent errors due to temporary locking of NetCDF files. 
export HDF5_USE_FILE_LOCKING=FALSE

# Stop the computation after an error occurs.
set -e
 
# For parallel processes, the lines below update the <process> element in the DIMR configuration file.
# The updated list of numbered partitions is calculated from the user specified number of nodes and cores.
# You DO NOT need to modify the lines below.
PROCESSSTR="$(seq -s " " 0 $((np-1)))"
sed -i "s/\(<process.*>\)[^<>]*\(<\/process.*\)/\1$PROCESSSTR\2/" $dimrconfigFolder/$dimrFile
# The name of the MDU file is read from the DIMR configuration file.
# You DO NOT need to modify the line below.
mduFile="$(sed -n 's/\r//; s/<inputFile>\(.*\).mdu<\/inputFile>/\1/p' $dimrconfigFolder/$dimrFile)".mdu


#--- Partition by calling the dflowfm executable -------------------------------------------------------------
if [ "$np" -gt 1 ]; then 
    echo ""
    echo "Partitioning parallel model..."
    cd "$mdufileFolder"
    echo "Partitioning in folder ${PWD}"
    dflowfm --nodisplay --autostartstop --partition:ndomains="$np":icgsolver=6 "$mduFile"
    
else 
    #--- No partitioning ---
    echo ""
    echo "Sequential model..."
fi 
 
#--- Simulation by calling the dimr executable ----------------------------------------------------------------
echo ""
echo "Simulation..."
cd $dimrconfigFolder
echo "Computing in folder ${PWD}"

#$containerFolder/execute_singularity_dimr.sh -c $containerFolder -m $modelFolder dimr "$dimrFile"
mpirun -np $np dimr "$dimrFile"

#--- Join output files by calling the dfmoutput executable ----------------------------------------------------------------
cd $input_folder/dflowfmoutput
echo "Joining nc files in folder ${PWD}"

run_dfmoutput.sh -- mapmerge --infile *map.nc

