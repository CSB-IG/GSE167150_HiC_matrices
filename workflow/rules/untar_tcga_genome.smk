#! /usr/bin/env python
# -*- coding utf-8 -*-

rule untar_tcga_genome:
    """ 
    Prepare reference genome files
    """
    output:
        config['sequences']['genome_fasta']
    input:
        config['sequences']['genome_tar_gz']
    params:
        original=config['sequences']['genome_fa']
    shell:
        '''
        outdir=$(dirname {output})
        mkdir -p $outdir
	tar\
            --extract\
            -z\
            --verbose\
            --file {input}\
            -C $outdir\
            && mv {params.original} {output}
        '''

