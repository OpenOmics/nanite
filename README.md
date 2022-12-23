<div align="center">
   
  <h1>nanite 🔬</h1>
  
  **_Viral Nanopore Pipeline_**

  [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7477632.svg)](https://doi.org/10.5281/zenodo.7477632) [![GitHub release (latest SemVer including pre-releases)](https://img.shields.io/github/v/release/OpenOmics/nanite?color=blue&include_prereleases)](https://github.com/OpenOmics/nanite/releases) [![Docker Pulls](https://img.shields.io/docker/pulls/skchronicles/nanite)](https://hub.docker.com/repository/docker/skchronicles/nanite)<br>[![tests](https://github.com/OpenOmics/nanite/workflows/tests/badge.svg)](https://github.com/OpenOmics/nanite/actions/workflows/main.yaml) [![docs](https://github.com/OpenOmics/nanite/workflows/docs/badge.svg)](https://github.com/OpenOmics/nanite/actions/workflows/docs.yml) [![GitHub issues](https://img.shields.io/github/issues/OpenOmics/nanite?color=brightgreen)](https://github.com/OpenOmics/nanite/issues)  [![GitHub license](https://img.shields.io/github/license/OpenOmics/nanite)](https://github.com/OpenOmics/nanite/blob/main/LICENSE) 
  
  <i>
    This is the home of the pipeline, nanite. Its long-term goals: to assemble, annotate, and screen nanopore samples like no pipeline before!
  </i>
</div>

## Overview
Welcome to nanite! Before getting started, we highly recommend reading through [nanite's documentation](https://openomics.github.io/nanite/).

The **`./nanite`** pipeline is composed several inter-related sub commands to setup and run the pipeline across different systems. Each of the available sub commands perform different functions: 

 * [<code>nanite <b>run</b></code>](https://openomics.github.io/nanite/usage/run/): Run the nanite pipeline with your input files.
 * [<code>nanite <b>unlock</b></code>](https://openomics.github.io/nanite/usage/unlock/): Unlocks a previous runs output directory.
 * [<code>nanite <b>install</b></code>](https://openomics.github.io/nanite/usage/install/): Download reference files locally.
 * [<code>nanite <b>cache</b></code>](https://openomics.github.io/nanite/usage/cache/): Cache software containers locally.

**nanite** is a streamlined viral metagenomics pipeline to assemble, annotate, and classify microorganisms in enviromental samples. It relies on technologies like [Singularity<sup>1</sup>](https://singularity.lbl.gov/) to maintain the highest-level of reproducibility. The pipeline consists of a series of data processing and quality-control steps orchestrated by [Snakemake<sup>2</sup>](https://snakemake.readthedocs.io/en/stable/), a flexible and scalable workflow management system, to submit jobs to a cluster.

The pipeline is compatible with data generated from [Nanopore sequencing technologies](https://nanoporetech.com/). As input, it accepts a set of FastQ files and can be run locally on a compute instance or on-premise using a cluster. A user can define the method or mode of execution. The pipeline can submit jobs to a cluster using a job scheduler like SLURM (more coming soon!). A hybrid approach ensures the pipeline is accessible to all users.

Before getting started, we highly recommend reading through the [usage](https://openomics.github.io/nanite/usage/run/) section of each available sub command.

For more information about issues or trouble-shooting a problem, please checkout our [FAQ](https://openomics.github.io/nanite/faq/questions/) prior to [opening an issue on Github](https://github.com/OpenOmics/nanite/issues).

## Dependencies
**Requires:** `singularity>=3.5`  `snakemake>=6.0`

At the current moment, the pipeline uses a mixture of enviroment modules and docker images; however, this will be changing soon! In the very near future, the pipeline will only use docker images. With that being said, [snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) and [singularity](https://singularity.lbl.gov/all-releases) must be installed on the target system. Snakemake orchestrates the execution of each step in the pipeline. To guarantee the highest level of reproducibility, each step of the pipeline will rely on versioned images from [DockerHub](https://hub.docker.com/orgs/nciccbr/repositories). Snakemake uses singularity to pull these images onto the local filesystem prior to job execution, and as so, snakemake and singularity will be the only two dependencies in the future.

## Installation
Please clone this repository to your local filesystem using the following command:
```bash
# Clone Repository from Github
git clone https://github.com/OpenOmics/nanite.git
# Change your working directory
cd nanite/
# Add dependencies to $PATH
# Biowulf users should run
module load snakemake singularity
# Get usage information
./nanite -h
```

## Contribute 
This site is a living document, created for and by members like you. nanite is maintained by the members of OpenOmics and is improved by continous feedback! We encourage you to contribute new content and make improvements to existing content via pull request to our [GitHub repository](https://github.com/OpenOmics/nanite).

## References
<sup>**1.**  Kurtzer GM, Sochat V, Bauer MW (2017). Singularity: Scientific containers for mobility of compute. PLoS ONE 12(5): e0177459.</sup>  
<sup>**2.**  Koster, J. and S. Rahmann (2018). "Snakemake-a scalable bioinformatics workflow engine." Bioinformatics 34(20): 3600.</sup>  
