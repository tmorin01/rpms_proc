#! /bin/bash -l

module load afni/2017.01.29.1818_openmp

SUB=$1
proj_dir=/projectnb/sternlab/tom/RPMS

# Go to subject's AFNI results directory
#cd $proj_dir/scan_data/$SUB/afni/$SUB.results
cd $proj_dir/scan_data/$SUB/afni/$SUB.results.nlregFSLdone.doublesub.vol
# Generate motion parameter 1D plot
1dplot -volreg -one -xlabel TR -ylabel mm -title $SUB -png motion.png dfile_rall.1D

# Find number of TRs showing > 3mm motion in any dimension
3dTstat -max -prefix mot.max.1D dfile_rall.1D
1deval -a mot.max.1D -expr 'step(a-3)' > mot.over3.1D
echo "Number of TRs with motion > 3mm:"
paste -sd+ mot.over3.1D | bc

# Open motion plot
xdg-open motion.png

# Return to the code directory
cd $proj_dir/code
