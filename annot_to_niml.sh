#!/bin/bash -l

#  Author: Tom Morin
#    Date: April, 2019
# Purpose: Convert Yeo7 and Yeo17 (and possibly other) Freesurfer .annot files
#          into .niml.dset files suitable for use in SUMA. Importantly, we move
#          the .annot files from fsaverage surf mesh into std.141.fsaverage surf
#          mesh.
#         Before using this script, run @SUMA_Make_Spec_FS on fsaverage, copy
#         results in $group_dir/suma_fsaverage

# Step 0: Load Modules 
module load afni/2017.01.29.1818_openmp
module load freesurfer
SUBJECTS_DIR=/projectnb/sternlab/tom/RPMS/scan_data
group_dir=/projectnb/sternlab/tom/RPMS/scan_data/afni_group/group.results.nlreg.distcorr.surf.regressAM

# Step 1: Navigate to SUBJECTS_DIR


for hemi in lh rh; do
    echo "===== Working on $hemi hemisphere"
    for nx in 7 17; do
        echo "========== Working on Yeo$nx Parcellation"
        echo "# Step 1: Navigate to SUBJECTS_DIR"
        cd $SUBJECTS_DIR

        # Step 2: Convert .annot to .gii
        echo "# Step 2: Convert .annot to .gii"
        mris_convert --annot fsaverage/label/$hemi.Yeo2011_${nx}Networks_N1000.annot \
                fsaverage/surf/$hemi.white \
                $group_dir/suma_fsaverage/$hemi.Yeo$nx.gii

        # Step 3: Convert .gii to .niml.dset
        echo "# Step 3: Convert .gii to .niml.dset"
        cd $group_dir/suma_fsaverage
        ConvertDset -o_niml -input $hemi.Yeo$nx.gii -prefix $hemi.Yeo$nx

        # Step 4: Map .niml.dset onto standard mesh
        echo "# Step 4: Map .niml.dset onto standard mesh"
        MapIcosahedron -spec fsaverage_$hemi.spec -ld 141 -NN_dset_map $hemi.Yeo$nx.niml.dset \
                -morph $hemi.sphere.gii -prefix std.141. -overwrite
    done
done

# Step 5: Extract Mean signal & number of vertices from each ROI in each Subject's stats map
#3dROIstats -mask suma_fsaverage/std.141.Yeo7.niml.dset \
#           -nzvoxels stats.RPMS_2001.lh.niml.dset_REML.niml.dset'[1,6,11,16]'




