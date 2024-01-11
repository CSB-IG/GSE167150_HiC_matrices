#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os

def get_runs(wildcards, s):
    _sruns = samples.loc[s]['runid']
    _layouts = runs.loc[_sruns]['layout']

    if not all(_ == 'PAIRED' for _ in _layouts):
        msg = f'All runs for sample "{s}" should be PAIRED for this rule'
        raise WorkflowError(msg)

    return expand("results/{{dataset}}/fastq/{samp}/{sra_run}_{r}.fastq.gz", samp=s, sra_run=_sruns, r=[1, 2])

def get_raw_files(wildcards):
    # obtain the samples from the dataset
    _samps = dsets.loc[wildcards.dataset]['sample']

    # for each sample, get the runs
    runs_list = [get_runs(wildcards, sample) for sample in _samps]

    # flatten the list of runs
    flattened_runs = [item for sublist in runs_list for item in sublist]
    
    return flattened_runs

rule run_hicpro:
    """
    Run Hi-C Pro on FASTQ files
    """
    output: 
        touch("results/{dataset}/hicpro/{dataset}_hicpro_complete.txt")
    input:
        get_raw_files,
        rules.restriction_fragments.output,
        rules.bowtie2_build.output,
        hicpro = lambda wc: os.path.realpath(config['software']['hicpro_bin']),
        hicpro_config = "resources/rendered_config_hicpro_files/{dataset}/config-hicpro.txt"
    params:
        fastq_dir = "results/{dataset}/fastq",
        out_dir = "results/{dataset}/hicpro"
    conda:
        "../envs/hicpro.yaml"
    shell:
        '''
        {input.hicpro}\
            -i {params.fastq_dir}\
            -o {params.out_dir}\
            -c {input.hicpro_config}
        '''

