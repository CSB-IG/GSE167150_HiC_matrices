#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os

def get_input_fastq(wildcards):
    _sruns = samples.loc[wildcards.samp]['runid']
    _layouts = runs.loc[_sruns]['layout']
    
    if not all(_ == 'PAIRED' for _ in _layouts):
        msg = f'All runs for sample "{wildcards.samp}" should be PAIRED for this rule'
        raise WorkflowError(msg)

    return expand("results/fastq/{{samp}}/{{samp}}/{sra_run}_{r}.fastq.gz", sra_run=_sruns, r=[1,2])

# The outputs from this rule are as many as fastq pairs (so one output for each rule).
# Hi-C Pairs from each run are only merged when allvalidpairs files (one per run) are available
# So should the sra_run wildcard not be expanded until that point? but how do I get the fastq files then? feed it the wildcard? from the following rule? 

rule hicpro_align:
    """
    Run Hi-C Pro bowtie mapping on FASTQ files
    """
    output:
        temp(directory("results/hicpro_alignment/{samp}/bowtie_results/bwt2_global")),
        temp(directory("results/hicpro_alignment/{samp}/bowtie_results/bwt2_local")),
        out_dir = directory("results/hicpro_alignment/{samp}/bowtie_results/bwt2")
    input:
        get_input_fastq,
        rules.restriction_fragments.output,
        rules.bowtie2_build.output,
        hicpro_bin = config['software']['hicpro_bin'],
        hicpro_config = rules.render_hicpro_config.output
    log:
        "logs/hicpro_align/{samp}-hicpro_align.log"
    benchmark:
        "benchmarks/hicpro_align/{samp}-hicpro_align.bmk"
    params:
        fastq_dir = "results/fastq/{samp}",
        hicpro = lambda wc: os.path.realpath(config['software']['hicpro_bin']),
        out_dir = "results/hicpro_alignment/{samp}"
    conda:
        "../envs/hicpro.yaml"
    shell:
        '''
        {params.hicpro}\
            --input {params.fastq_dir}\
            --output {params.out_dir}\
            --conf {input.hicpro_config}\
            --step mapping
        '''

