#! /usr/bin/env python
# -*- coding utf-8 -*-

# function to determine if the curl command has special options or not
#
def curl_common_args(wildcards):
    if wildcards.file == config['sequences']['genome_tar_gz']:
        return config['download_tcga_genome']['args']
    else:
        return f" > {output}"
    
rule remote_download:
    """
    Downloads a remote file and checks the md5sum
    """
    conda:
        "../envs/remote_download.yaml"
    output:
        'resources/downloads/{file}'
    params:
        url = lambda wildcards: config['downloads'][wildcards.file]['url'],
        md5 = lambda wildcards: config['downloads'][wildcards.file]['md5'],
        common_args = curl_common_args

    shell:
        '''
	curl\
            -L {params.url}\
            {params.common_args}

        echo "{params.md5}  {output}" | md5sum -c -
        '''

