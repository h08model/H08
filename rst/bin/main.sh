#!/bin/bash
# ===========================================================================
# Created By  : Yuki Ishikawa
# Created Date: 2023-10-10
# * Program to execute the restart simulation
# ===========================================================================
### PBS settings if needed
#PBS -N H08_RST
#PBS -q F40                            
#PBS -l nodes=node39:ppn=30
#PBS -o /cluster/data7/yishikawa/H08_Restart/rst/log/H08-RST_output.log
#PBS -e /cluster/data7/yishikawa/H08_Restart/rst/log/H08-RST_error.log
#PBS -M yishikawa@rainbow.iis.u-tokyo.ac.jp
#PBS -m ea
#PBS -V
# for PBS users
#cd $PBS_O_WORKDIR

# others
cd "/home/tamaoki/H08"
# ===========================================================================
# Jobs
# ===========================================================================
## Activate the python virtual environment (conda)
#source activate pyh08

## Activate the python virtual environment (venv)
source rst/pyh08/bin/activate

## Run the simulation
python rst/bin/run_h08.py

wait

echo "Completed the simulations!"
