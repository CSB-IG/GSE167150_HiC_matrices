#! /usr/bin/env python
# -*- coding utf-8 -*-

import os

rule render_hicpro_config:
    """ 
    Use jinja template to render a config file for hicpro
    """
    output:
        "resources/hicpro/config-hicpro.txt"
    input:
        "resources/template_config-hicpro.txt"
    params:
        threads = config['hicpro']['threads'],
        memory = config['hicpro']['sort_mem'],
        index = lambda wc: os.path.realpath(config['hicpro']['bwt2_index']),
        refgenome = config['hicpro']['ref'],
        chromosomes = lambda wc: os.path.realpath(config['hicpro']['chr_sizes']),
        fragments = lambda wc: os.path.realpath(rules.restriction_fragments.output[0]), # Extract the single file path and convert to realpath
        ligations = config['hicpro']['ligation_site'],
        bins = config['hicpro']['resolutions']
    template_engine:
        "jinja2" 

