#!/usr/bin/env bash

t1_niigz=$(pwd)/INPUTS/t1.nii.gz
out_dir=$(pwd)/OUTPUTS
nmt_dir=$(pwd)/NMT_v2.0_asym

# Work in the output dir
cd "${out_dir}"

# Reorient data ordering to make FSL happy
echo Reorient
fslreorient2std "${t1_niigz}" t1.nii.gz

# Initial rigid registration to "low res" 0.5mm template
echo Initial rigid registration
flirt \
    -in t1.nii.gz \
    -ref "${nmt_dir}"/NMT_v2.0_asym_05mm/NMT_v2.0_asym_05mm.nii.gz \
    -dof 6 \
    -out t1_6dof \
    -omat t1_to_nmt_6dof.mat

