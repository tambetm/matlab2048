#!/bin/bash

/storage/software/MATLAB_R2013b/bin/matlab -nodisplay -nosplash -nojvm -r "experiment1($(($SLURM_PROCID + 1)),$1)"
