#!/usr/bin/env python3

# This script finds each phenotype's allvalidpairs files and symlinks them as .validpairs files

import os
import pandas as pd

# Load the metadata
metadata = pd.read_csv('config/hic_samples_metadata.csv')

# Iterate over each row in the metadata table
for _, row in metadata.iterrows():
    sample = row['sample']
    merger = row['merger']
    
    # Construct the directory and file paths
    avp_dir = f"results/hicpro_allvpairs/{sample}/hic_results/data/{sample}/"
    avp_file = f"{sample}.allValidPairs"
    
    # Get the real path of the .allValidPairs file
    avp_path = os.path.realpath(os.path.join(avp_dir, avp_file))
    
    # Prepare the target directory and symlink name
    target_dir = f"results/hicpro_merged/hicpro_pairs/{merger}/"
    os.makedirs(target_dir, exist_ok=True)
    symlink_name = os.path.join(target_dir, f"{sample}.validPairs")
    
    # Create the symlink
    if not os.path.exists(symlink_name):
        os.symlink(avp_path, symlink_name)
        print(f"Symlink created: {symlink_name} -> {avp_path}")
    else:
        print(f"Symlink already exists: {symlink_name}")

print("Symlinks creation completed.")
