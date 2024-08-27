#!/bin/bash

# Directories
input_dir="results/hicpro_merged/hicpro_phenotypes/hic_results/matrix"
output_raw_dir="results/h5_merged_contacts_raw"
output_iced_dir="results/h5_merged_contacts_iced"

# Loop over all samples in the input directory
for sample in $(ls $input_dir); do
    for type in "raw" "iced"; do
        resolution_dir="$input_dir/$sample/$type"
        
        if [[ $type == "raw" ]]; then
            output_dir="$output_raw_dir/$sample"
            suffix=""
        elif [[ $type == "iced" ]]; then
            output_dir="$output_iced_dir/$sample"
            suffix="_iced"
        fi

        # Create output directory if it doesn't exist
        mkdir -p $output_dir

        # Convert each matrix file at each resolution
        for resolution in $(ls $resolution_dir); do
            matrix_file="${sample}_${resolution}${suffix}.matrix"
            output_file="$output_dir/${sample}_${resolution}${suffix}.h5"

            # Check if the output file already exists
            if [[ -f $output_file ]]; then
                echo "Output file $output_file already exists, skipping..."
            else
                if [[ $type == "raw" ]]; then
                    bed_file="$resolution_dir/$resolution/${sample}_${resolution}_abs.bed"
                else
                    # Use the corresponding raw BED file for iced
                    bed_file="$input_dir/$sample/raw/$resolution/${sample}_${resolution}_abs.bed"
                fi

                # Run hicConvertFormat
                echo "Converting $resolution_dir/$resolution/$matrix_file to $output_file"
                hicConvertFormat -m $resolution_dir/$resolution/$matrix_file --bedFileHicpro $bed_file --inputFormat hicpro --outputFormat h5 -o $output_file
            fi
        done
    done
done
