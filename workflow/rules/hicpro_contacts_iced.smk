#! /usr/bin/env python
# -*- coding: utf-8 -*-

# eventually we will need to add to the output the matrices for each sample and resolution
# they can be de input to downstream networks or differential itneractions programs

rule hicpro_contacts_iced:
    """
    Run Hi-C Pro step that applies ICE normalization to raw matrix
    """
    output:
        out_dir = directory("results/hicpro_contacts_iced/{samp}/hic_results/matrix")
    input:
        in_dir = rules.hicpro_contacts_raw.output['out_dir'],
        hicpro_bin = config['software']['hicpro_bin'],
        hicpro_config = rules.render_hicpro_config.output
    params:
        hicpro = lambda wc: os.path.realpath(config['software']['hicpro_bin']),
        out_dir = "results/hicpro_contacts_iced/{samp}"
    conda:
        "../envs/hicpro.yaml"
    shell:
        '''
        {params.hicpro}\
            --input {input.in_dir}\
            --output {params.out_dir}\
            --conf {input.hicpro_config}\
            --step ice_norm
        '''

