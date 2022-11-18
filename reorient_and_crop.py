#!/usr/bin/env python

import argparse
import json
import nibabel

parser = argparse.ArgumentParser()
parser.add_argument('--acmm', nargs=3, type=float, required=True)
parser.add_argument('--nifti', required=True)
parser.add_argument('--json', required=True)
parser.add_argument('--position', default='sphinx')
parser.add_argument('--out', required=True)
args = parser.parse_args()

# Get Patient Position 0018,5100 from the dcm2niix json sidecar
with open(args.json, 'r') as f:
  hdr = json.load(f)

# Reorientation
img = nibabel.nifti1.load(args.nifti)
newaff = img.affine.copy()
if hdr['PatientPosition']=='HFS' and args.position=='sphinx':
    # Swap Y, Z axes, and flip in X to retain handedness
    newaff[0, :] = -img.affine[0, :]
    newaff[1, :] = img.affine[2, :]
    newaff[2, :] = img.affine[1, :]
else:
    raise Exception(
        f'Unable to reorient for Patient Position {hdr["PatientPosition"]} ' 
        f'and actual position {args.position}'
        )
img.set_qform(newaff)
img.set_sform(newaff)
img.to_filename(args.out)

# Crop extents from provided anterior commissure coordinate for macaque
xmin = args.acmm[0] - 40
xmax = args.acmm[0] + 40

ymin = args.acmm[1] - 50
ymax = args.acmm[1] + 40

zmin = args.acmm[2] - 30
zmax = args.acmm[2] + 30

