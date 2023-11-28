#!/usr/bin/env bash

singularity run --cleanenv --contain \
    --bind $(pwd -P)/INPUTS:/INPUTS \
    --bind $(pwd -P)/OUTPUTS:/OUTPUTS \
    /data/mcr/centos7/singularity/connstats-roi_v1.0.1.sif \
    matrix_csv /INPUTS/Z_removegm.csv \
    out_dir /OUTPUTS \
    seed_roi DMN_LatPar_L \
