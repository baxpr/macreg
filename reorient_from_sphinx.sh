#!/usr/bin/env bash
#
# Monkey position is prone with 90 deg posterior head tilt (sphinx position).
# But scanner setting is "supine". This rearrangement of the qform/sform is 
# specific to this situation

# Get sform of anat image, split to array
S=($(fslorient -getsform t1))

# Rearrange sform
newS=\
"-${s[0]} -${s[1]} -${s[2]} -${s[3]} "\
"${s[8]} ${s[9]} ${s[10]} ${s[11]} "\
"${s[4]} ${s[5]} ${s[6]} ${s[7]} "\
"${s[12]} ${s[13]} ${s[14]} ${s[15]} "

# Fix (delete) doubled negative signs
newS=${newS//--/}

echo "Changing sform from"
echo "   ${S[@]}"
echo "   to"
echo "   ${newS}"
fslorient -setsform ${newS} t1

# Copy corrected sform to qform
echo Copying to qform
fslorient -copysform2qform t1
