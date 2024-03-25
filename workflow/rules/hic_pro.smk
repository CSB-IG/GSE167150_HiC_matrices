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
    _samps = datasets.loc[wildcards.dataset]['sample']

    # for each sample, get the runs
    runs_list = [get_runs(wildcards, sample) for sample in _samps]

    # flatten the list of runs
    flattened_runs = [item for sublist in runs_list for item in sublist]
    
    return flattened_runs

def get_allvalidpairs(wildcards):
    samps = datasets.loc[wildcards.dataset]['sample']

    return expand("results/{{dataset}}/hicpro/hic_results/data/{samp}/{samp}.allValidPairs", samp=samps)

rule run_hicpro:
    """
    Run Hi-C Pro on FASTQ files
    """
    output: 
        temp("results/{dataset}/hicpro/bowtie_results/bwt2_global"),
        temp("results/{dataset}/hicpro/bowtie_results/bwt2_local"),
        touch("results/{dataset}/hicpro/{dataset}.complete"),
        get_allvalidpairs
    input:
#       hicpro = lambda wc: os.path.realpath(config['software']['hicpro_bin']),
        get_raw_files,
        "resources/{dataset}/fragments.bed",
        rules.bowtie2_build.output,
        hicpro_config = "resources/{dataset}/config-hicpro.txt"
    params:
        # hicpro will emulate the input fastq directory structure for the output
        fastq_dir = "results/{dataset}/fastq",
        out_dir = "results/{dataset}/hicpro"
    container:
        'docker://nservant/hicpro:latest'
    shell:
        '''
#       {input.hicpro}\
        HiC-Pro\
            -i {params.fastq_dir}\
            -o {params.out_dir}\
            -c {input.hicpro_config}
        '''

