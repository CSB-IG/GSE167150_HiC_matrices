#! /usr/bin/env python
# -*- coding: utf-8 -*-

# We will need to add to this rule the matrix and abs files for each sample and resolution
# because each matrix and bins combination is the input for the network generating program

rule hicpro_contacts_raw:
    """
    Run Hi-C Pro step that builds contact raw matrix
    """
    output:
        out_dir = directory("results/hicpro_contacts_raw/{samp}/hic_results/matrix")
    input:
        in_dir = rules.hicpro_allvalidpairs.output['out_dir']#,
#        hicpro_bin = config['software']['hicpro_bin'],
#        hicpro_config = rules.render_hicpro_config.output
    params:
        hicpro = lambda wc: os.path.realpath(config['software']['hicpro_bin']),
        out_dir = "results/hicpro_contacts_raw/{samp}",
        hicpro_config = "resources/hicpro/config-hicpro.txt"
    conda:
        "../envs/hicpro.yaml"
    shell:
        '''
        {params.hicpro}\
            --input {input.in_dir}\
            --output {params.out_dir}\
            --conf {params.hicpro_config}\
            --step build_contact_maps
        '''

