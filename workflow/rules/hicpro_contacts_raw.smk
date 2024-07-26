#! /usr/bin/env python
# -*- coding: utf-8 -*-

rule hicpro_contacts_raw:
    """
    Run Hi-C Pro step that builds contact raw matrix
    """
    output:
        out_dir = directory("results/hicpro_contacts_raw/{samp}/hic_results/matrix")
    input:
        in_dir = rules.hicpro_allvalidpairs.output['out_dir'],
        hicpro_bin = config['software']['hicpro_bin'],
        hicpro_config = rules.render_hicpro_config.output
    params:
        hicpro = lambda wc: os.path.realpath(config['software']['hicpro_bin']),
        out_dir = "results/hicpro_contacts_raw/{samp}"
    conda:
        "../envs/hicpro.yaml"
    shell:
        '''
        {params.hicpro}\
            --input {input.in_dir}\
            --output {params.out_dir}\
            --conf {input.hicpro_config}\
            --step build_contact_maps
        '''

