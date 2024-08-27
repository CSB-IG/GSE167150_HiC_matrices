#! /usr/bin/env python
# -*- coding: utf-8 -*-


# get the samples from each merger

#mergers = pd.DataFrame(meta_table.groupby('merger')['sample'].apply(list))
def get_avp(wildcards):
    ds = mergers.loc[wildcards.sample]['dataset']
    return expand("results/{dataset}/hicpro/hic_results/data/{{sample}}/{{sample}}.allValidPairs", dataset=ds)

# mergers should not depend on the dataset, because we might want to 
# merge samples from different datasets
# do different enzymes allow merging?
#
# rule to generate symlinks to the deduplicated allvalidpairs
rule symlink_avp:
    """
    Symlink allValidPairs files into validPairs files
    """
    output:
        "results/mergers/allvalidpairs/{merger}/{sample}.validPairs"
    input:
        get_avp
    params:
        outdir = "results/mergers/allvalidpairs/{merger}"
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

def get_avp_files(wildcards):
    _samps = mergers.loc[wildcards.merger]['sample']

# HOW WILL WE KNOW WHICH MERGERS ARE FROM WHICH DATASET, is it always implied?
# is it that we only need to solve that at the level of all targets?
    return expand("results/{{dataset}}/merged_allvalidpairs/{merger}/{sample}.validPairs", sample=_samps)

def get_raw_files(wildcards):
    # obtain the samples from the dataset
    _samps = datasets.loc[wildcards.dataset]['sample']

    # for each sample, get the runs
    runs_list = [get_runs(wildcards, sample) for sample in _samps]
    
    # flatten the list of runs
    flattened_runs = [item for sublist in runs_list for item in sublist]

    return flattened_runs

rule run_hicpro_merger:
    """
    Run Hi-C Pro on FASTQ files
    """
    output:
        touch("results/mergers/hicpro/mergers.complete")
    input:
        get_avp_files,
        nodedup_hicpro_config = rules.merger_config.output,
    params:
        avp_dir = "results/mergers/allvalidpairs"
        out_dir = "results/mergers/hicpro"
    container:
        'docker://nservant/hicpro:latest'
    shell:
        '''
        HiC-Pro\
            -i {params.avp_dir}\
            -o {params.out_dir}\
            -c {input.nodedup_hicpro_config}
            -s merge_persample build_contact_maps ice_norm
        '''

