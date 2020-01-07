#!/bin/bash -l
#
#  Author: Tom Morin
#    Date: December, 2018
# Purpose: Copy output from dcmunpack into directory structure for afni proc scripts
#
# Requires: In each subdirectory (3danat, rest, bold, etc.) make sure you include
#           a file called runs. ("/n" delimited file listing each of the runs 
#           you'd like to use in the proc analysis)

module load afni/2017.01.29.1818_openmp
module load freesurfer

SUBJECTS_DIR=/projectnb/sternlab/tom/RPMS/scan_data

while read subj
do
    # Create afni directory
    echo "Make afni dir..."
    mkdir -p $SUBJECTS_DIR/$subj/afni/$subj

    # Copy stim timing data
    echo "Copy stim timing files..."
    cp /projectnb/sternlab/tom/RPMS/timing_files/afni_timing_files/${subj}_*.txt $SUBJECTS_DIR/$subj/afni/$subj/

    # Copy anatomical file and convert to brik/head
    echo "Copy 3danat..."
    while read run
    do
        3dcopy $SUBJECTS_DIR/$subj/3danat/$run/memprage1_rms.nii $SUBJECTS_DIR/$subj/afni/$subj/${subj}_anat+orig -overwrite
    done<$SUBJECTS_DIR/$subj/3danat/runs

    # Copy each bold file and convert to brik/head
    echo "Copy bold runs..."
    i=1
    while read run
    do
        echo "Copy run $i..."
        3dcopy $SUBJECTS_DIR/$subj/bold/$run/f.nii $SUBJECTS_DIR/$subj/afni/$subj/${subj}_epi_r$i -overwrite
        ((i++))
    done<$SUBJECTS_DIR/$subj/bold/runs

    # Copy each fieldmap and convert to brik/head
    echo "Copy field maps..."
    pair=1
    i=1
    while read run
    do
        if [ $i -eq 1 ]; then
            echo "Copy fieldmap AP"
            3dcopy $SUBJECTS_DIR/$subj/fieldmap/$run/f_ap.nii $SUBJECTS_DIR/$subj/afni/$subj/${subj}_fieldmap_ap+orig -overwrite
            ((i++))
        elif [ $i -eq 2 ]; then
            echo "Copy fieldmap PA"
           3dcopy $SUBJECTS_DIR/$subj/fieldmap/$run/f_pa.nii $SUBJECTS_DIR/$subj/afni/$subj/${subj}_fieldmap_pa+orig -overwrite
            i=1
        fi
        ((pair++))
    done<$SUBJECTS_DIR/$subj/fieldmap/runs

    # Copy SUMA information (NEEDSWORK: Add line above this to run @SUMA_Make_Spec_FS)
    echo "Generating SUMA directory..."

    # Get FS output in AFNI Readable format
    @SUMA_Make_Spec_FS -NIFTI -fspath $SUBJECTS_DIR/$subj/surf -sid $subj

    # Generate subject-specific caudate/putament ROIs for each hemisphere
    echo "Generating Caudate/Putamen ROIs..."
    cd $SUBJECTS_DIR/$subj/surf/SUMA
    whereami -atlas aparc.a2009s+aseg_rank -mask_atlas_region aparc.a2009s+aseg_rank::Left-Putamen
    whereami -atlas aparc.a2009s+aseg_rank -mask_atlas_region aparc.a2009s+aseg_rank::Right-Putamen
    whereami -atlas aparc.a2009s+aseg_rank -mask_atlas_region aparc.a2009s+aseg_rank::Left-Caudate
    whereami -atlas aparc.a2009s+aseg_rank -mask_atlas_region aparc.a2009s+aseg_rank::Right-Caudate

    #echo "Moving SUMA dir to afni dir..."
    mv $SUBJECTS_DIR/$subj/surf/SUMA $SUBJECTS_DIR/$subj/afni/$subj/SUMA
    3dcopy $SUBJECTS_DIR/$subj/afni/$subj/SUMA/${subj}_SurfVol.nii $SUBJECTS_DIR/$subj/afni/$subj/SUMA/${subj}_SurfVol+orig
    
done<$SUBJECTS_DIR/sessids





