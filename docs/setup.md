## Dependencies

> **Requires**:  
> `singularity>=3.5 snakemake>=6.0`  
> _or_  
> `conda/mamba snakemake>=6.0`  

[Snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) must be installed on the target system. Snakemake is a workflow manager that orchestrates each step of the pipeline. The second dependency, i.e [singularity](https://singularity.lbl.gov/all-releases) OR [conda/mamba](https://github.com/conda-forge/miniforge#mambaforge), handles the dowloading/installation of any remaining software dependencies. 

By default, the pipeline will utilize singularity; however, the `--use-conda` option of the [run](usage/run.md) sub command can be provided to  use conda/mamba instead of singularity. If possible, we recommend using singularity over conda for reproducibility; however, it is worth noting that singularity and conda produce identical results for this pipeline. If you are running the pipeline on Windows, please use the [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install). Singularity can be installed on WSL following these [instructions](https://www.blopig.com/blog/2021/09/using-singularity-on-windows-with-wsl2/).

You can check to see if nanite's software requirements are met by running:
```bash
# Check if dependencies 
# are already installed 
which snakemake || echo 'Error: snakemake is not install.'
which singularity \
  || which conda \
  || which mamba \
  || echo 'Error: singularity or conda or mamba are not installed.'
```


## Installation

Please ensure the software dependencies listed above are satisfied before getting started with this section. Also, please ensure each of the software dependencies listed above are in your `$PATH`. You can re-run the same command above to ensure each of the required dependencies are in your `$PATH`.

You can install nanite locally with the following command:
```bash
# Clone nanite from Github
git clone https://github.com/OpenOmics/nanite.git
# Change your working directory
cd nanite/
# Biowulf users should run
# Get usage information
./nanite -h
```

## Offline mode

The `nanite` pipeline can be run in an offline mode where external requests are not made at runtime. This will cache and download and remote resources or software containers (if using singlarity). Please note that if you are running the pipeline on Biowulf, you do NOT need to run these next steps. These instructions are for users running the pipeline outside of Biowulf cluster, i.e. on another cluster or locally on a laptop.

#### Download resource bundle

To download the pipeline's resource bundle, please run the following command:
```bash
# Dry-run download of the resource bundle
  nanite install --ref-path /data/$USER/refs \
             --force --threads 4 --dry-run
# Download the resource bundle
nanite install --ref-path /data/$USER/refs \
           --force --threads 4
```

Please remember the path provided to the `--ref-path` option above. During the download process, a new child directory called `nanite` will be created. The path to this directory should be provided to the `--resource-bundle` option of the [run sub command](usage/run.md). For more information, please see the documentation for the [install sub command](usage/install.md).

#### Cache software containers

This next step is only applicable for singularity users. If you are using conda/mamba instead of singularity, you can skip over this section. To cache remote software containers, please run the following command:
```bash
# Dry run to see what will
# be pulled from DockerHub
./nanite cache --sif-cache /data/$USER/cache --dry-run
# Cache software containers
./nanite cache --sif-cache /data/$USER/cache
```

Please remember the path provided to the `--sif-cache` option above, you will need to provide this path to the `--sif-cache` option of the [run sub command](usage/run.md). For more information, please see the documentation for the [cache sub command](usage/install.md). 
