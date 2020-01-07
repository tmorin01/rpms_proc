#!/bin/bash -l

module load afni/2017.01.29.1818_openmp

pdir=/projectnb/sternlab/tom/RPMS/scan_data/afni_group/group.results.regressAM.etac

mkdir -p $pdir/cluster_stats

while read CON
do
    # Mask the activity map by the cluster results from 3dttest++ with ETAC
    3dcalc -a $pdir/$CON+tlrc -b $pdir/$CON.default.ETACmask.global.2sid.5perc.nii.gz -exp '(a*b)' -prefix $pdir/${CON}_ETAC_activity

    # Clusterize and print cluster coordinates/stats to 1D file
    3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -dxyz=1 1.01 20 $pdir/${CON}_ETAC_activity+tlrc.HEAD > $pdir/cluster_stats/${CON}_clusters.1D

    # Estimate the region of each cluster
    whereami -coord_file $pdir/cluster_stats/${CON}_clusters.1D'[13,14,15]' -tab -space MNI > $pdir/cluster_stats/${CON}_regions.txt
done<$1
    
