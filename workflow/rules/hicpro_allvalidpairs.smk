#! /usr/bin/env python
# -*- coding: utf-8 -*-

rule hicpro_allvalidpairs:
    """
    Run Hi-C Pro step that deduplicates and merges valid pairs per sample
    The hic_results stats directory is created 
    """
    output:
        out_dir = directory("results/hicpro_allvpairs/{samp}/hic_results/data"),
        sample_allvalidpairs = "results/hicpro_allvpairs/{sample}/hic_results/data/{sample}/{sample}.allValidPairs"
    input:
        in_dir = rules.hicpro_pairs.output['out_dir']#,
#        hicpro_bin = config['software']['hicpro_bin'],
#        hicpro_config = rules.render_hicpro_config.output
    params:
        hicpro = lambda wc: os.path.realpath(config['software']['hicpro_bin']),
        out_dir = "results/hicpro_allvpairs/{samp}",
        hicpro_config = "resources/hicpro/config-hicpro.txt"
    conda:
        "../envs/hicpro.yaml"
    shell:
        '''
        {params.hicpro}\
            --input {input.in_dir}\
            --output {params.out_dir}\
            --conf {params.hicpro_config}\
            --step merge_persample
        '''

