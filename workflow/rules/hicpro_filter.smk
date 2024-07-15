#! /usr/bin/env python
# -*- coding: utf-8 -*-

rule hicpro_filter:
    """
    Run Hi-C Pro step that filters alignments on BAM files
    """
    output:
        out_dir = "results/hicpro_filter/{samp}"
    input:
        bams_dir = "results/hicpro_alignment/{samp}",
        hicpro = lambda wc: os.path.realpath(config['software']['hicpro_bin']),
        hicpro_config = rules.render_hicpro_config.output
    conda:
        "../envs/hicpro.yaml"
    shell:
        '''
        {input.hicpro}\
            --input {input.bams_dir}\
            --output {output.out_dir}\
            --conf {input.hicpro_config}\
            --step proc_hic
        '''

