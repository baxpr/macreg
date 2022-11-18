#!/usr/bin/env bash

t1_niigz=$(pwd)/INPUTS/t1.nii.gz
t1_json=$(pwd)/INPUTS/t1.json
acijk_csv=$(pwd)/INPUTS/t1_acijk.csv
out_dir=$(pwd)/OUTPUTS
nmt_dir=$(pwd)/NMT_v2.0_sym/NMT_v2.0_sym_fh

# Reorient and crop to make flirt happy
echo Reorient and crop
reorient_and_crop.py \
    --nii "${t1_niigz}" \
    --json "${t1_json}" \
    --acijk_csv "${acijk_csv}" \
    --position sphinx \
    --outnii "${out_dir}"/rt1.nii.gz

# Reorder data in file to make flirt happy
echo Reorder to standard
fslreorient2std "${out_dir}"/rt1 "${out_dir}"/srt1

# Work in the output dir now
cd "${out_dir}"

# Register. Rigid body first to keep the affine step tame. Use brain mask
# in the affine step
flirt \
    -dof 6 \
    -usesqform \
    -in srt1 \
    -ref "${nmt_dir}"/NMT_v2.0_sym_fh.nii.gz \
    -out rsrt1 \
    -omat srt1_to_nmt_6.mat

flirt \
    -usesqform \
    -in rsrt1 \
    -ref "${nmt_dir}"/NMT_v2.0_sym_fh.nii.gz \
    -refweight "${nmt_dir}"/NMT_v2.0_sym_fh_brainmask.nii.gz \
    -out arsrt1 \
    -omat rsrt1_to_nmt.mat

# Combine transformations and apply
convert_xfm -omat srt1_to_nmt.mat -concat rsrt1_to_nmt.mat srt1_to_nmt_6.mat
flirt \
    -init srt1_to_nmt.mat \
    -applyxfm \
    -in srt1 \
    -ref "${nmt_dir}"/NMT_v2.0_sym_fh.nii.gz \
    -out asrt1
