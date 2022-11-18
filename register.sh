#!/usr/bin/env bash

t1_niigz=$(pwd)/INPUTS/t1.nii.gz
out_dir=$(pwd)/OUTPUTS
nmt_dir=$(pwd)/NMT_v2.0_sym

# Work in the output dir
cd "${out_dir}"

# Reorient data ordering to make FSL happy
echo Reorient
fslreorient2std "${t1_niigz}" t1.nii.gz

# Initial rigid registration
echo Initial rigid registration
flirt -v \
    -in t1.nii.gz \
    -ref "${nmt_dir}"/NMT_v2.0_sym_fh/NMT_v2.0_sym_fh.nii.gz \
    -dof 6 \
    -searchrx -180 180 -searchry -180 180 -searchrz -180 180 \
    -coarsesearch 90 \
    -out t1_6dof \
    -omat t1_to_nmt_6dof.mat

