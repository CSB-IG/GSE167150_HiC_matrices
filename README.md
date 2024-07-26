# Snakemake workflow: `<name>`

change this repos name to "brca_hic"


You run this using

`snakemake --cores 58 --use-conda`


Eventually we might use the proper output files in the HiC-Pro rules, but for now the rules outputs are the directories, because that is the way HiC-Pro asks for the input

We're just gonna commit this now and branch into trying out the actual output files version because we're currently getting

```
ImproperOutputException in rule hicpro_filter in file /STORAGE/genut/hreyes/GSE167150_HiC-Pro.git/workflow/rules/hicpro_filter.smk, line 4:
Outputs of incorrect type (directories when expecting files or vice versa). Output directories must be flagged with directory(). for rule hicpro_filter:
    output: results/hicpro_filter/ZR7530_rep2_GSM5098067
    wildcards: samp=ZR7530_rep2_GSM5098067
    affected files:
        results/hicpro_filter/ZR7530_rep2_GSM5098067
``` 

To merge sample replicates we must
symlink the `.allValidPairs` from each replicate as `validPairs` and run the hicpro_allvalidpairs.smk rule on them 

## Requirements

- snakemake





[![Snakemake](https://img.shields.io/badge/snakemake-≥6.3.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/<owner>/<repo>/workflows/Tests/badge.svg?branch=main)](https://github.com/<owner>/<repo>/actions?query=branch%3Amain+workflow%3ATests)


A Snakemake workflow for `<description>`


## Usage

The usage of this workflow is described in the [Snakemake Workflow Catalog](https://snakemake.github.io/snakemake-workflow-catalog/?usage=<owner>%2F<repo>).

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) <repo>sitory and its DOI (see above).

# TODO

* Replace `<owner>` and `<repo>` everywhere in the template (also under .github/workflows) with the correct `<repo>` name and owning user or organization.
* Replace `<name>` with the workflow name (can be the same as `<repo>`).
* Replace `<description>` with a description of what the workflow does.
* The workflow will occur in the snakemake-workflow-catalog once it has been made public. Then the link under "Usage" will point to the usage instructions if `<owner>` and `<repo>` were correctly set.
