#!/bin/bash -p

# jonathan polimeni <jonp@nmr.mgh.harvard.edu>
# Thursday, September 12, 2013 21:17:37 -0400
# Tuesday, September 24, 2013 21:09:48 -0400

# /space/padkeemao/1/users/jonp/lwlab/PROJECTS/notebooks/2013_09_09__SMS_slice_timing_correction/sms_slicetime_correct.sh

# requires FreeSurfer tools "stc.fsl" and "mri_info",
# and FSL tools "fslsplit" and "fslmerge"

# *assumes* FSLOUTPUTTYPE is 'NIFTI_GZ'

version="0.3"

if [ $# -eq 0 ]; then
    echo "  usage:  `basename $0` MB instem outstem"
    exit 0
fi

MB=$1

echo MB factor is ${MB}

infile=$2
instem=`echo $infile | sed - -e s/.gz$// | sed -e s/\.nii//`
instem=$(basename $instem) # remove path
outfile=$3
outstem=`echo $outfile | sed - -e s/.gz$// | sed -e s/\.nii//`

if [[ -z "$outstem" ]]; then
    outstem=${instem}_stc
    echo setting output to ${outstem}
fi

outdir=`dirname ${outstem}`

Nslc=`mri_info --nslices ${infile}`
TRms=`mri_info --tr      ${infile}`

# note MB factor is same as Nslicegroups (i.e., groups of slices
# acquired simultaneously)

# assumes Nslc is divisible by MB
Ntimegroups=$[Nslc/MB]

# note: Ntimegroups is same as slices per group (spg)
remainder=`expr $Nslc - $[Ntimegroups * MB]`

if [[ $remainder -ne 0 ]]; then
    echo error
fi

tmpdir="${outdir}/sms_slicetime_correct.tmp$$.`date +%s`"

mkdir -p ${tmpdir}

if [ "$?" -ne 0 ]; then
    exit 1
fi

echo -e '\nsplitting input data'
fslsplit ${infile} ${tmpdir}/${instem}__ -z


echo -e '\nperforming slice timing correction on slice-groups'
slicegroup_list=''
for slicegroup in `seq -f %02.0f 0 $(( ${MB} - 1 ))`; do
    echo -e "\nslicegroup ${slicegroup} of `printf %02.0f ${MB}`"

    firstslice=$(( ${Ntimegroups} * ${slicegroup} ))

    cmd="fslmerge -z ${tmpdir}/slicegroup_${slicegroup}.nii `seq -f '${tmpdir}/${instem}__%04.0f.nii.gz' ${firstslice} 1 $(( ${firstslice} + ${Ntimegroups} - 1 ))`"
    echo ${cmd}
    eval ${cmd}

    $FREESURFER_HOME/fsfast/bin/stc.fsl --i ${tmpdir}/slicegroup_${slicegroup}.nii.gz --o ${tmpdir}/slicegroup_${slicegroup}_stc.nii.gz --siemens

    fslsplit ${tmpdir}/slicegroup_${slicegroup}_stc.nii.gz ${tmpdir}/slicegroup_${slicegroup}_stc__ -z

    slicegroup_list="${slicegroup_list} ${tmpdir}/slicegroup_${slicegroup}_stc__*"

done;

echo -e '\nre-merging corrected data'

#echo ${slicegroup_list}
fslmerge -z ${outstem} ${slicegroup_list}

rm -rfv ${tmpdir}/slicegroup* ${tmpdir}/${instem}__*


exit 0

