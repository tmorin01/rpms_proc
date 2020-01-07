#!/bin/bash -l

module load fsl

fslmaths harvardoxford-subcortical_prob_Right_Caudate_2mm.nii.gz -thr 50 -bin r.caudate.2mm
fslmaths harvardoxford-subcortical_prob_Left_Caudate_2mm.nii.gz -thr 50 -bin l.caudate.2mm
fslmaths harvardoxford-subcortical_prob_Right_Putamen_2mm.nii.gz -thr 50 -bin r.putamen.2mm
fslmaths harvardoxford-subcortical_prob_Left_Putamen_2mm.nii.gz -thr 50 -bin l.putamen.2mm

fslmaths r.caudate.2mm -mul 2 tmp1
fslmaths l.putamen.2mm -mul 3 tmp2
fslmaths r.putamen.2mm -mul 4 tmp3

fslmaths l.caudate.2mm -add tmp1 -add tmp2 -add tmp3 bg.rois
