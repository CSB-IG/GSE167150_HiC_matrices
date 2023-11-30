#! /usr/bin/env python
# -*- coding: utf-8 -*-

rule bowtie2_build:
    input:
        ref=config['sequences']['genome_fasta']
    output:
        multiext(
            config['bowtie_alignment']['index'],
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2",
        )
    log:
        "logs/bowtie2_build/build.log",
    params:
        extra="",  # optional parameters
    threads: 8
    wrapper:
        "v2.9.1/bio/bowtie2/build"

