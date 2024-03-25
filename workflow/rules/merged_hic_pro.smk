#! /usr/bin/env python
# -*- coding: utf-8 -*-

# rule to generate symlinks to the deduplicated allvalidpairs
rule symlink_avp:
    """
    Symlink allValidPairs files into validPairs files
    """
    output:
        "results/{dataset}/merged_allvalidpairs/{merger}/{sample}.validPairs"
    input:
        "results/{dataset}/hicpro/hic_results/data/{sample}/{sample}.allValidPairs"
    params:
        outdir = "results/{dataset}/merged_allvalidpairs/{merger}"
    shell:
        """
        mkdir -p {params.outdir}

        i=$(realpath {input})

        ln -s $i {output}
        """

rule merger_config:
    """
    Create HiC-Pro config file that doesnt remove duplicates
    (because they have been previously removed)
    """
    output:
        "resources/{dataset}/merged_config-hicpro.txt"
    input:
        "resources/{dataset}/config-hicpro.txt"
    shell:
        """
        cp {input} {output}

        sed -i 's/RM_DUP = 1/RM_DUP = 0/' {output}
        """

# rule to run Hi-C Pro on the mergers

def get_avp_files(wildcards):
    _samps = mergers.loc[wildcards.merger]['sample']

    _sruns = samples.loc[s]['runid']
    _layouts = runs.loc[_sruns]['layout']

    if not all(_ == 'PAIRED' for _ in _layouts):
        msg = f'All runs for sample "{s}" should be PAIRED for this rule'
        raise WorkflowError(msg)

# HOW WILL WE KNOW WHICH MERGERS ARE FROM WHICH DATASET
    "results/{dataset}/merged_allvalidpairs/{merger}/{sample}.validPairs"
    
    return expand("results/{{dataset}}/fastq/{samp}/{sra_run}_{r}.fastq.gz", samp=s, sra_run=_sruns, r=[1, 2])

rule run_hicpro:
    """
    Run Hi-C Pro on FASTQ files
    """
    output: 
        touch("results/{dataset}/merged_hicpro/{merger}_hicpro_complete.txt")
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
        HiC-Pro -i results/hic_tissue_PRJNA703392/merged_avp -o results/hic_tissue_PRJNA703392/hicpro_merged -c resources/rendered_config_hicpro_files/hic_tissue_PRJNA703392/config-hicpro_merged.txt -s merge_persample build_contact_maps ice_norm
        # the input is a directory where I symlinked each sample's ALL VALID PAIRS as one valid pairs each
        # the output is a new directory
        # the config is a copy of the original config with one change in the remove duplicates parameters (this time set to false, because the "valid pairs" have already been deduplicated)
        # the steps are just merge, build maps, ice normalization
        {input.hicpro}\
            -i {params.fastq_dir}\
            -o {params.out_dir}\
            -c {input.hicpro_config}
        '''

