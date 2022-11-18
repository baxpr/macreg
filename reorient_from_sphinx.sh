#!/usr/bin/env bash
#
# Monkey position is prone with 90 deg posterior head tilt (sphinx position).
#
# But scanner setting is "supine" - specifically, Patient Position 0018,5100 is 
# "HFS" (head-first supine) - and the Nifti file is mislabeled accordingly.
#
# This rearrangement of the qform/sform is specific to this situation.

# Get sform of anat image, split to array
S=($(fslorient -getsform t1))

# Rearrange sform. We swap Y, Z axes, and flip in X to retain handedness 
# (avoid left/right reversal).
newS=\
"-${S[0]} -${S[1]} -${S[2]} -${S[3]} "\
"${S[8]} ${S[9]} ${S[10]} ${S[11]} "\
"${S[4]} ${S[5]} ${S[6]} ${S[7]} "\
"${S[12]} ${S[13]} ${S[14]} ${S[15]} "

# Fix doubled negative signs by deleting them
newS=${newS//--/}

echo "Changing sform from"
echo "   ${S[@]}"
echo "   to"
echo "   ${newS}"
fslorient -setsform ${newS} t1

# Copy corrected sform to qform
echo Copying to qform
fslorient -copysform2qform t1
