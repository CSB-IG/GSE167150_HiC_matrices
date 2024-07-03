#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os

def get_runs(wildcards, s):
    _sruns = samples.loc[s]['runid']
    _layouts = runs.loc[_sruns]['layout']

    if not all(_ == 'PAIRED' for _ in _layouts):
        msg = f'All runs for sample "{s}" should be PAIRED for this rule'
        raise WorkflowError(msg)

    return expand("results/fastq/{samp}/{sra_run}_{r}.fastq.gz", samp=s, sra_run=_sruns, r=[1, 2])

# sadly, samp is not a wildcard here, so we have to get it from somewhere
# the dataframe samples index is what I need, for each of those, I need to create the expanded files

def get_input_fastq(wildcards):
    # obtain the samples
    _samps = samples.index.to_list()

    # for each sample, get the runs
    runs_list = [get_runs(wildcards, sample) for sample in _samps]

    # flatten the list of runs
    flattened_runs = [item for sublist in runs_list for item in sublist]
    
    return flattened_runs

#def get_allvalidpairs(wildcards):
#    samps = datasets.loc[wildcards.dataset]['sample']
#
#    return expand("results/hicpro/hic_results/data/{samp}/{samp}.allValidPairs", samp=samps)

rule run_hicpro:
    """
    Run Hi-C Pro on FASTQ files
    """
    output: 
        temp("results/hicpro/bowtie_results/bwt2_global"),
        temp("results/hicpro/bowtie_results/bwt2_local"),
        touch("results/hicpro/.complete")
#        get_allvalidpairs
    input:
        get_input_fastq,
        rules.restriction_fragments.output,
        rules.bowtie2_build.output,
        hicpro_config = rules.render_hicpro_config.output,
        hicpro = lambda wc: os.path.realpath(config['software']['hicpro_bin'])
    params:
        # hicpro will emulate the input fastq directory structure for the output
        fastq_dir = "results/fastq",
        out_dir = "results/hicpro"
    conda:
        "../envs/hicpro.yaml"
    shell:
        '''
        {input.hicpro}\
            -i {params.fastq_dir}\
            -o {params.out_dir}\
            -c {input.hicpro_config}
        '''

