#! /usr/bin/env python
# -*- coding utf-8 -*-

rule restriction_fragments:
    """ 
    Digest reference genome with Hi-C enzyme
    """
    output:
        config['digestion']['arima']['bed']
    input:
        config['sequences']['genome_fasta']
    params:
        enzyme = config['digestion']['arima']['enzyme'],
        script = "workflow/scripts/digest_genome.py"
    shell:
        '''
        python {params.script}\
            -r {params.enzyme}\
            -o {output}\
            {input}
        '''

