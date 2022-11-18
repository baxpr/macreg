#!/usr/bin/env bash

flirt -dof 6 -usesqform -in out -ref ../NMT_v2.0_sym/NMT_v2.0_sym_fh/NMT_v2.0_sym_fh.nii.gz \
    -out rout -omat dof6.mat

flirt -dof 12 -usesqform -in rout -ref ../NMT_v2.0_sym/NMT_v2.0_sym_fh/NMT_v2.0_sym_fh.nii.gz \
    -refweight ../NMT_v2.0_sym/NMT_v2.0_sym_fh/NMT_v2.0_sym_fh_brainmask.nii.gz \
    -out rrout -omat dof12.mat


# Check impact of params
sch=$FSLDIR/etc/flirtsch/measurecost1.sch
flirt -in out -ref tp -schedule $sch
flirt -init dof6.mat -in out -ref tp -schedule $sch

flirt -in rout -ref tp -schedule $sch
flirt -in rrout -ref tp -schedule $sch
