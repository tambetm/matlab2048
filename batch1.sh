#!/bin/bash
#SBATCH --partition=long
#SBATCH --ntasks-per-node 10
#SBATCH --cpus-per-task 2
#SBATCH --mem 4096
#SBATCH --time=100:00:00
#SBATCH --mail-type=end
#SBATCH --mail-user=tambet@ut.ee

srun -l -n 9 ./wrapper1.sh 3000
