#!/usr/bin/env python

import argparse
import json
import nibabel
import numpy
import pandas

parser = argparse.ArgumentParser()
parser.add_argument('--nii', required=True)
parser.add_argument('--json', required=True)
parser.add_argument('--acijk_csv', required=True)
parser.add_argument('--position', default='sphinx')
parser.add_argument('--fovmm', nargs=3, type=float, default=[40, 30, 50])
parser.add_argument('--outnii', required=True)
args = parser.parse_args()

# Get Patient Position 0018,5100 from the dcm2niix json sidecar
with open(args.json, 'r') as f:
  hdr = json.load(f)

# Get AC location from the csv file
acijk = pandas.read_csv(args.acijk_csv, header=None)
if acijk.shape != (1, 3):
    raise Exception('Error in AC coord csv')

# Reorientation
img = nibabel.nifti1.load(args.nii)
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
#img.set_qform(newaff)
#img.set_sform(newaff)

# Crop extents from provided anterior commissure coordinate for macaque.
# Crop box is specified in mm, so we scale by the voxel size. AC coordinate 
# is VOXEL location (not mm) in the original image (not the reoriented 
# image). FOV is symmetrical around the AC point
vox = img.header.get_zooms()
ijkmin = [acijk[n][0] - args.fovmm[n]/vox[n] for n in range(3)]
ijkmax = [acijk[n][0] + args.fovmm[n]/vox[n] for n in range(3)]

# Matrices of voxel coords
vsize = img.header.get_data_shape()
ci, cj, ck = numpy.meshgrid(
    range(vsize[0]),
    range(vsize[1]),
    range(vsize[2]),
    indexing='ij'
    )
imgdata = img.get_fdata()
newimgdata = numpy.zeros_like(imgdata)
keepinds = (
    (ci>=ijkmin[0]) & (ci<=ijkmax[0]) &
    (cj>=ijkmin[1]) & (cj<=ijkmax[1]) &
    (ck>=ijkmin[2]) & (ck<=ijkmax[2])
    )
newimgdata[keepinds] = imgdata[keepinds]

#ci<ijkmin[0] or ci>ijkmax[0]] = 0
#imgdata[ci>ijkmax[0]] = 0

imgout = nibabel.nifti1.Nifti1Image(newimgdata, newaff)
imgout.to_filename(args.outnii)
