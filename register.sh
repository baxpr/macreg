#!/usr/bin/env bash

t1_niigz=$(pwd)/INPUTS/t1.nii.gz
t1_json=$(pwd)/INPUTS/t1.json
acijk_csv=$(pwd)/INPUTS/t1_acijk.csv
out_dir=$(pwd)/OUTPUTS
nmt_dir=$(pwd)/NMT_v2.0_sym

# Reorient and crop to make flirt happy
echo Reorient and crop
reorient_and_crop.py \
    --nii "${t1_niigz}" \
    --json "${t1_json}" \
    --acijk_csv "${acijk_csv}" \
    --position sphinx \
    --outnii "${out_dir}"/rt1.nii.gz

# Reorient data ordering to make FSL happy
echo Reorder to standard
fslreorient2std "${out_dir}"/rt1 "${out_dir}"/srt1
