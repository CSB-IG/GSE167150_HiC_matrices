#!/bin/bash

# Function to convert HiC-Pro matrix to h5 format
convert_to_h5() {
    local matrix_file=$1
    local bed_file=$2
    local output_file=$3
    
    if [ -f "$output_file" ]; then
        echo "File $output_file already exists. Skipping conversion."
    else
        echo "Converting $matrix_file to $output_file..."
        hicConvertFormat --matrices "$matrix_file" --bedFileHicpro "$bed_file" --inputFormat hicpro --outFileName "$output_file" --outputFormat h5
    fi
}

# Base directories
raw_dir="results/hicpro_contacts_raw"
iced_dir="results/hicpro_contacts_iced"
h5_raw_dir="results/h5_contacts_raw"
h5_iced_dir="results/h5_contacts_iced"

# Loop through the sample directories in the raw directory
for sample_dir in "$raw_dir"/*/; do
    sample=$(basename "$sample_dir")
    
    # Create corresponding directories in h5_contacts_raw and h5_contacts_iced
    mkdir -p "${h5_raw_dir}/${sample}"
    mkdir -p "${h5_iced_dir}/${sample}"
    
    # Find available resolutions in the raw directory
    resolutions=$(ls "${raw_dir}/${sample}/hic_results/matrix/${sample}/raw/" | grep -E '^[0-9]+$')
    
    for res in $resolutions; do
        raw_matrix_file="${raw_dir}/${sample}/hic_results/matrix/${sample}/raw/${res}/${sample}_${res}.matrix"
        bed_file="${raw_dir}/${sample}/hic_results/matrix/${sample}/raw/${res}/${sample}_${res}_abs.bed"
        raw_output_file="${h5_raw_dir}/${sample}/${sample}_${res}.h5"

        iced_matrix_file="${iced_dir}/${sample}/hic_results/matrix/${sample}/iced/${res}/${sample}_${res}_iced.matrix"
        iced_output_file="${h5_iced_dir}/${sample}/${sample}_${res}_iced.h5"

        # Convert raw matrix
        convert_to_h5 "$raw_matrix_file" "$bed_file" "$raw_output_file"

        # Convert iced matrix
        convert_to_h5 "$iced_matrix_file" "$bed_file" "$iced_output_file"
    done
done
