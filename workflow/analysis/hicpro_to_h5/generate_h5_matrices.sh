# generate_h5_matrices.sh
# The commands in this script were run from the top directory
#
# what these commands do:
# Convert each unmerged (replicates) and merged (by phenotype) from 
# HiC-Pro matrix format (.matrix and .bed) to h5 format
# using HiCExplorer, see:
# https://hicexplorer.readthedocs.io/en/latest/content/tools/hicConvertFormat.html

# this is run from the top directory 
cd /STORAGE/genut/hreyes/GSE167150_HiC-Pro.git

##### Convert HiC-Pro format to h5 format 
#
# activate HiCExplorer environment (created from the yaml in envs)
conda activate hicexplorer

# convert HiC-Pro individual matrices
workflow/analysis/hicpro_to_h5/convert_hicpro_to_h5.sh

# converte HiC-Pro merged phenotype matrices
workflow/analysis/hicpro_to_h5/convert_merged_hicpro_to_h5.sh

