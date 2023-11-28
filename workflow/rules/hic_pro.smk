#! /usr/bin/env python
# -*- coding: utf-8 -*-

def get_runs(wildcards, s):
    _sruns = samples.loc[s]['runid']
    _layouts = runs.loc[_sruns]['layout']

    if not all(_ == 'PAIRED' for _ in _layouts):
        msg = f'All runs for sample "{s}" should be PAIRED for this rule'
        raise WorkflowError(msg)

    return expand("results/{{dataset}}/fastq/{samp}/{sra_run}_{r}.fastq.gz", samp=s, sra_run=_sruns, r=[1,2])

def get_fastq_files(wildcards):
    # obtain the samples from the dataset
    _samps = dsets.loc[wildcards.dataset][sample]

    # for each sample do the runs and layouts check
    # obtain its runs and flatten runs list
    runs_list = [item for sample in _samps for item in get_runs(sample)]

    # return all runs
    return(runs_list)


rule run_hicpro:
    """
    Run Hi-C Pro on FASTQ files
    """
    output: 
        directory("results/{dataset}/hicpro")
    input:
        get_fastq_files,
        rules.restriction_fragments.output,
        rules.bowtie2_build.output,
        hicpro_config = "results/{dataset}/hicpro/config-hicpro.txt" 
    params:
        fastq_dir = "results/{dataset}/fastq"
    container:
    shell:
        '''
        HiC-Pro\
            -i {params.fastq_dir}\
            -o {output}\
            -c {input.hicpro_config}
        '''

