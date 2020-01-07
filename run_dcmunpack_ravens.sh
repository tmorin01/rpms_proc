#!/bin/bash -l

#$ -N unpack2034

module load freesurfer/5.3.0

SUB=RPMS_2035

dcmunpack -src /projectnb/sternlab/tom/RPMS/raw_data/$SUB/$SUB/scans \
-targ /projectnb/sternlab/tom/RPMS/scan_data/$SUB \
-run 18 bold nii f.nii \
-run 20 bold nii f.nii \
-run 22 bold nii f.nii \
-run 24 bold nii f.nii \
-run 26 bold nii f.nii \
-run 28 bold nii f.nii \
-run 12 rest nii f.nii \
-run 14 rest nii f.nii \
-run 16 rest nii f.nii \
-run 9 fieldmap nii f_ap.nii \
-run 10 fieldmap nii f_pa.nii \
-run 7 3danat nii memprage_1.nii \
-run 8 3danat nii memprage1_rms.nii

