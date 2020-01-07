#!/bin/bash -l

#  Author: Tom Morin
#    Date: April, 2019
# Purpose: Extract average signal and number of vertices present in each ROI
#          from the Yeo7 and Yeo17 parcellations for a statistical map

# Contrast Key:
# =============
# 1  = TxtU#0_Coef
# 6  = TxtR#0_Coef
# 11 = SymU#0_Coef
# 16 = SymR#0_Coef
# 21 = Sym-Txt_mean#0_Coef
# 27 = Rule-Uni_mean#0_Coef
# 33 = TxtR-TxtU_mean#0_Coef
# 39 = SymR-SymU_mean#0_Coef
# 69 = Double_Sub_mean#0_Coef


# Step 0: Load Modules 
module load afni/2017.01.29.1818_openmp
SUBJECTS_DIR=/projectnb/sternlab/tom/RPMS/scan_data
group_dir=$SUBJECTS_DIR/afni_group/group.results.nlregFSLdone.doublesub.surf

cd $group_dir
mkdir -p roi_stats/yeo17.indiv.stats
mkdir -p roi_stats/yeo17.nx.stats
mkdir -p roi_stats/yeo7.indiv.stats
mkdir -p roi_stats/yeo7.nx.stats

while read subj
do
    echo "Working on subject $subj"
    for hemi in lh rh; do
        echo "===== Working on $hemi hemisphere"
         # Yeo 7 Indiv Parcellation
        echo "========== Working on Yeo7 Indiv Nodes ROI Analysis"
        touch roi_stats/yeo7.indiv.stats/$subj.$hemi.yeo7.indiv.stats
        3dROIstats -mask suma_fsaverage/std.141.$hemi.7Networks.indiv.niml.dset \
                    -nzvoxels \
                    stats.$subj.${hemi}_REML.niml.dset'[1,6,11,16,21,27,33,39,69]' > \
        roi_stats/yeo7.indiv.stats/$subj.$hemi.yeo7.indiv.stats

         # Yeo 7 Nx Parcellation
        echo "========== Working on Yeo7 Full Nx ROI Analysis"
        touch roi_stats/yeo7.nx.stats/$subj.$hemi.yeo7.nx.stats
        3dROIstats -mask suma_fsaverage/std.141.$hemi.Yeo7.niml.dset \
                    -nzvoxels \
                    stats.$subj.${hemi}_REML.niml.dset'[1,6,11,16,21,27,33,39,69]' > \
        roi_stats/yeo7.nx.stats/$subj.$hemi.yeo7.nx.stats
        
        # Yeo 17 Indiv Parcellation
        echo "========== Working on Yeo17 Indiv Nodes ROI Analysis"
        touch roi_stats/yeo17.indiv.stats/$subj.$hemi.yeo17.indiv.stats
        3dROIstats -mask suma_fsaverage/std.141.$hemi.17Networks.indiv.niml.dset \
                    -nzvoxels \
                    stats.$subj.${hemi}_REML.niml.dset'[1,6,11,16,21,27,33,39,69]' > \
        roi_stats/yeo17.indiv.stats/$subj.$hemi.yeo17.indiv.stats

        # Yeo 17 Nx Parcellation
        echo "========== Working on Yeo17 Full Nx ROI Analysis"
        touch roi_stats/yeo17.nx.stats/$subj.$hemi.yeo17.nx.stats
        3dROIstats -mask suma_fsaverage/std.141.$hemi.Yeo17.niml.dset \
                    -nzvoxels \
                    stats.$subj.${hemi}_REML.niml.dset'[1,6,11,16,21,27,33,39,69]' > \
        roi_stats/yeo17.nx.stats/$subj.$hemi.yeo17.nx.stats
    done
done<$SUBJECTS_DIR/good_subs


