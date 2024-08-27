#!/bin/bash

# Define the base directory where your Hi-C Pro matrices are located
base_dir="results/hicpro_contacts_raw"

# Define the output directory for the .h5 files
output_base_dir="results/h5_contacts_raw"

# Loop through each sample directory
for sample_dir in $base_dir/*/; do
    # Extract the sample name from the directory path
    sample=$(basename $sample_dir)
    
    # Define the matrix and bed file directory
    matrix_dir="${sample_dir}hic_results/matrix/${sample}/raw"
    
    # Loop through each resolution directory
    for resolution_dir in $matrix_dir/*/; do
        # Extract the resolution from the directory path
        resolution=$(basename $resolution_dir)
        
        # Define the Hi-C Pro matrix file and bed file
        matrix_file="${resolution_dir}${sample}_${resolution}.matrix"
        bed_file="${resolution_dir}${sample}_${resolution}_abs.bed"
        
        # Define the output directory and output file name
        output_dir="${output_base_dir}/${sample}"
        output_file="${output_dir}/${sample}_${resolution}.h5"
        
        # Create the output directory if it doesn't exist
        mkdir -p $output_dir
        
        # Convert the Hi-C Pro matrix to .h5 format
        hicConvertFormat -m $matrix_file --bedFileHicpro $bed_file --inputFormat hicpro --outputFormat h5 -o $output_file
        
        echo "Converted ${sample} at resolution ${resolution} to ${output_file}"
    done
done
