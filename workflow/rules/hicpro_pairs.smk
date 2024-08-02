#! /usr/bin/env python
# -*- coding: utf-8 -*-

rule hicpro_pairs:
    """
    Run Hi-C Pro step that filters alignments on BAM files and creates HiC pairs
    The quality checks step produces the hic_results pic directory
    """
    output:
        out_dir = directory("results/hicpro_pairs/{samp}/hic_results/data")
    input:
        in_dir = rules.hicpro_align.output['out_dir']#,
#        hicpro_bin = config['software']['hicpro_bin'],
#        hicpro_config = rules.render_hicpro_config.output
    params:
        hicpro = lambda wc: os.path.realpath(config['software']['hicpro_bin']),
        out_dir = "results/hicpro_pairs/{samp}",
        hicpro_config = "resources/hicpro/config-hicpro.txt"
    conda:
        "../envs/hicpro.yaml"
    shell:
        '''
        {params.hicpro}\
            --input {input.in_dir}\
            --output {params.out_dir}\
            --conf {params.hicpro_config}\
            --step proc_hic\
            --step quality_checks
        '''

