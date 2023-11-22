#!/usr/bin/env bash

docker run \
    --mount type=bind,src=$(pwd -P),dst=/wkdir \
    --mount type=bind,src=$(pwd -P)/INPUTS,dst=/INPUTS \
    --mount type=bind,src=$(pwd -P)/OUTPUTS,dst=/OUTPUTS \
    baxterprogers/connstats-roi:v1.0.1 \
    matrix_csv /INPUTS/Z_removegm.csv \
    out_dir /OUTPUTS \
    seed_roi DMN_LatPar_L

