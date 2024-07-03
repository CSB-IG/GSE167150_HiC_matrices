#! /usr/bin/env python
# -*- coding utf-8 -*-

rule install_hicpro:
    """
    Decompress HiC-Pro tar gz and then install
    because it is not available in conda
    """
    conda:
        "../envs/hicpro.yaml"
    output:
        config['software']['hicpro_bin']
    input:
        config['software']['hicpro_targz']
    params:
        outdir = config['software']['hicpro_dir'],
        idir = config['tmpdir']

    shell:
        '''
        mkdir -p {params.outdir}
        
        tar\
        --extract\
        -z\
        --verbose\
        --file {input}\
        -C {params.outdir}\
        --strip-components=1

        # this is actually repulsive
        cd {params.outdir}

        install_dir={params.idir}
        sed -i "s|PREFIX = .*|PREFIX = $install_dir|" config-install.txt

        make configure
        make install
        '''

