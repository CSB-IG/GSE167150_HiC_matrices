#! /usr/bin/env python
# -*- coding utf-8 -*-

rule render_hicpro_config:
    """ 
    Use jinja template to render a config file for hicpro
    """
    output:
        "resources/{dataset}/config-hicpro.txt"
    input:
        "resources/template_config-hicpro.txt"
    params:
        threads = lambda wc: config['hicpro'][wc.dataset]['threads'],
        memory = lambda wc: config['hicpro'][wc.dataset]['sort_mem'],
        index = lambda wc: config['hicpro'][wc.dataset]['bwt2_index'],
        refgenome = lambda wc: config['hicpro'][wc.dataset]['ref'],
        chromosomes = lambda wc: config['hicpro'][wc.dataset]['chr_sizes'],
        fragments = lambda wc: config['hicpro'][wc.dataset]['genome_frags'],
        ligations = lambda wc: config['hicpro'][wc.dataset]['ligation_site'],
        bins = lambda wc: config['hicpro'][wc.dataset]['resolutions']
    template_engine:
        "jinja2" 

