
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

###### symlinks per sample (requires pandas)
python workflow/analysis/merge_bioreplicates/create_symlinks.py  

##### create HiC-Pro config 
#
# Copy the original config file to the new location
cp resources/hicpro/config-hicpro.txt resources/hicpro/merged_config-hicpro.txt

# Modify the new config file to set RM_DUP = 0
sed -i 's/RM_DUP = 1/RM_DUP = 0/' resources/hicpro/merged_config-hicpro.txt

##### run HiC-Pro per phenotype
#
# activate HiC-Pro environment (created from the yaml in envs)
conda activate hicpro

# run HiC-Pro
resources/software/hicpro/bin/HiC-Pro -i results/hicpro_merged/hicpro_pairs -o results/hicpro_merged/hicpro_phenotypes -c resources/hicpro/merged_config-hicpro.txt -s merge_persample -s build_contact_maps -s ice_norm

