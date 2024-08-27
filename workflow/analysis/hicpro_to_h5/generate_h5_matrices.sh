# generate_h5_matrices.sh
# The commands in this script were run from the top directory
#
# what this commands do:
# finds each phenotype's allvalidpairs files and symlinks them as .validpairs files
# generates a hicpro config that does not remove duplicates
# runs hicpro steps merge_persample, build_contact_maps, ice_norm
#
# the result are hic matrices per phenotype

# this is run from the top directory 
cd /STORAGE/genut/hreyes/GSE167150_HiC-Pro.git

##### Convert HiC-Pro format to h5 format 
#
# activate HiCExplorer environment (created from the yaml in envs)
conda activate hicexplorer

# convert HiC-Pro individual matrices
workflow/analysis/hicpro_to_h5/convert_hicpro_to_h5.sh

# converte HiC-Pro merged phenotype matrices

