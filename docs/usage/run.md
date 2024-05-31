# <code>nanite <b>run</b></code>

## 1. About 
The `nanite` executable is composed of several inter-related sub commands. Please see `nanite -h` for all available options.

This part of the documentation describes options and concepts for <code>nanite <b>run</b></code> sub command in more detail. With minimal configuration, the **`run`** sub command enables you to start running nanite pipeline. 

Setting up the nanite pipeline is fast and easy! In its most basic form, <code>nanite <b>run</b></code> only has *two required inputs*.

## 2. Synopsis
```text
$ nanite run [--help] \
      [--dry-run] [--job-name JOB_NAME] [--mode {slurm,local}] \
      [--sif-cache SIF_CACHE] [--singularity-cache SINGULARITY_CACHE] \
      [--silent] [--threads THREADS] [--tmp-dir TMP_DIR] \
      [--resource-bundle RESOURCE_BUNDLE] [--use-conda] \
      [--conda-env-name CONDA_ENV_NAME] \
      [--quality-filter QUALITY_FILTER] \
      [--assemble-reads] \
      --input INPUT [INPUT ...] \
      --output OUTPUT
```

The synopsis for each command shows its arguments and their usage. Optional arguments are shown in square brackets.

A user **must** provide a list of FastQ (globbing is supported) to analyze via `--input` argument and an output directory to store results via `--output` argument.

Use you can always use the `-h` option for information on a specific command. 

### 2.1 Required arguments

Each of the following arguments are required. Failure to provide a required argument will result in a non-zero exit-code.

  `--input INPUT [INPUT ...]`  
> **Input Oxford Nanopore FastQ files(s).**  
> *type: file(s)*  
> 
> One or more FastQ files can be provided. From the command-line, each input file should seperated by a space. Globbing is supported! This makes selecting FastQ files easy. Input FastQ files should always be gzipp-ed. If a sample has multiple fastq files for different barcodes, the pipeline expects each barcoded FastQ file endwith the following extension: `_N.fastq.gz`, where `N` is a number. Internally, the pipeline will concatenate each of these FastQ files prior to processing the data. Here is an example of an input sample with multiple barcode sequences: `S1_0.fastq.gz`, `S1_1.fastq.gz`, `S1_2.fastq.gz`, `S1_3.fastq.gz`. Given this barcoded sample, the pipeline will create the following concatenated FastQ file: `S1.fastq.gz`. 
> 
> ***Example:*** `--input .tests/*.fastq.gz`

---  
  `--output OUTPUT`
> **Path to an output directory.**   
> *type: path*
>   
> This location is where the pipeline will create all of its output files, also known as the pipeline's working directory. If the provided output directory does not exist, it will be created automatically.
> 
> ***Example:*** `--output /data/$USER/nanite_out`

### 2.2 Analysis options

Each of the following arguments are optional, and do not need to be provided. 

  `--quality-filter QUALITY_FILTER`  
> **Quality score filter.**  
> *type: int*
> *default: 8*
> 
> This option filters reads on a minimum average quality score. Any reads with an average minimum quality score less than this threshold will be removed. The default average minimum quality filter is set to 8.
> 
> ***Example:*** `--quality-filter 10`

  `--assemble-reads`  
> **Assemble reads.**  
> *type: boolean flag*
> 
> Assemble reads and recover high-quality viral genomes using Flye and viralFlye. This option will assemble reads using Flye while viralFlye is used to recover viral genomes using Flye's output. By default, this option is not enabled, meaning it will not perform any assemble steps. If you would like to enable assemble reads and recover any pontential viral genomes, please provide this option. It is worth noting that assembling reads has the potential to use a significant amount of computational resources, specifically high memory usage. Internal testing has shown that the pipeline can use up to 8-16GB of memory when assembling reads into repeat graphs. If you provide this option, please ensure that you have enough memory available on the host or local machine before proceeding.  
> 
> ***Example:*** `--assemble-reads`

### 2.3 Orchestration options

Each of the following arguments are optional, and do not need to be provided. 

  `--dry-run`            
> **Dry run the pipeline.**  
> *type: boolean flag*
> 
> Displays what steps in the pipeline remain or will be run. Does not execute anything!
>
> ***Example:*** `--dry-run`

---  
  `--silent`            
> **Silence standard output.**  
> *type: boolean flag*
> 
> Reduces the amount of information directed to standard output when submitting master job to the job scheduler. Only the job id of the master job is returned.
>
> ***Example:*** `--silent`

---  
  `--mode {slurm,local}`  
> **Execution Method.**  
> *type: string*  
> *default: slurm*
> 
> Execution Method. Defines the mode or method of execution. Vaild mode options include: slurm or local. 
> 
> ***slurm***    
> The slurm execution method will submit jobs to the [SLURM workload manager](https://slurm.schedmd.com/). It is recommended running nanite in this mode as execution will be significantly faster in a distributed environment. This is the default mode of execution.
>
> ***local***  
> Local executions will run serially on compute instance. This is useful for testing, debugging, or when a users does not have access to a high performance computing environment. If this option is not provided, it will default to a local execution mode. 
> 
> ***Example:*** `--mode slurm`

---  
  `--job-name JOB_NAME`  
> **Set the name of the pipeline's master job.**  
> *type: string*
> *default: pl:nanite*
> 
> When submitting the pipeline to a job scheduler, like SLURM, this option always you to set the name of the pipeline's master job. By default, the name of the pipeline's master job is set to "pl:nanite".
> 
> ***Example:*** `--job-name pl_id-42`

---  
  `--singularity-cache SINGULARITY_CACHE`  
> **Overrides the $SINGULARITY_CACHEDIR environment variable.**  
> *type: path*  
> *default: `--output OUTPUT/.singularity`*
>
> Singularity will cache image layers pulled from remote registries. This ultimately speeds up the process of pull an image from DockerHub if an image layer already exists in the singularity cache directory. By default, the cache is set to the value provided to the `--output` argument. Please note that this cache cannot be shared across users. Singularity strictly enforces you own the cache directory and will return a non-zero exit code if you do not own the cache directory! See the `--sif-cache` option to create a shareable resource. 
> 
> ***Example:*** `--singularity-cache /data/$USER/.singularity`

---  
  `--sif-cache SIF_CACHE`
> **Path where a local cache of SIFs are stored.**  
> *type: path*  
>
> Uses a local cache of SIFs on the filesystem. This SIF cache can be shared across users if permissions are set correctly. If a SIF does not exist in the SIF cache, the image will be pulled from Dockerhub and a warning message will be displayed. The `nanite cache` subcommand can be used to create a local SIF cache. Please see `nanite cache` for more information. This command is extremely useful for avoiding DockerHub pull rate limits. It also remove any potential errors that could occur due to network issues or DockerHub being temporarily unavailable. We recommend running nanite with this option when ever possible.
> 
> ***Example:*** `--singularity-cache /data/$USER/SIFs`

---  
  `--threads THREADS`   
> **Max number of threads for each process.**  
> *type: int*  
> *default: 2*
> 
> Max number of threads for each process. This option is more applicable when running the pipeline with `--mode local`.  It is recommended setting this vaule to the maximum number of CPUs available on the host machine.
> 
> ***Example:*** `--threads 12`

---  
  `--tmp-dir TMP_DIR`   
> **Max number of threads for each process.**  
> *type: path*  
> *default: `/lscratch/$SLURM_JOBID`*
> 
> Path on the file system for writing temporary output files. By default, the temporary directory is set to '/lscratch/$SLURM_JOBID' for backwards compatibility with the NIH's Biowulf cluster; however, if you are running the pipeline on another cluster, this option will need to be specified. Ideally, this path should point to a dedicated location on the filesystem for writing tmp files. On many systems, this location is set to somewhere in /scratch. If you need to inject a variable into this string that should NOT be expanded, please quote this options value in single quotes.
> 
> ***Example:*** `--tmp-dir /scratch/$USER/`

---  
  `--resource-bundle RESOURCE_BUNDLE`
> **Path to a resource bundle downloaded with the install sub command.**  
> *type: path*  
>
> The resource bundle contains the set of required reference files for processing any data. The path provided to this option will be the path to the `nanite` directory that was created when running the install sub command. Please see the install sub command for more information about downloading the pipeline's resource bundle.
> 
> ***Example:*** `--resource-bundle /data/$USER/refs/nanite`

---  
  `--use-conda`   
> **Use Conda/mamba instead of Singularity.**  
> *type: boolean flag*
> 
> Use Conda/Mamba instead of Singularity. By default, the pipeline uses singularity for handling required software dependencies. This option overrides that behavior, and it will use Conda/mamba instead of Singularity. The use of Singuarity and Conda are mutually exclusive. Please note that conda and mamba must be in your $PATH prior to running the pipeline. This option will build a conda environment on the fly prior to the pipeline's execution. As so, this step requires internet access. To run nanite in an offline mode with conda, please see the `--conda-env-name` option below. 
> 
> ***Example:*** `--use-conda`

---  
  `--conda-env-name CONDA_ENV_NAME`   
> **Use an existing conda environment.**  
> *type: str*
> 
> Use an existing conda environment. This option allows nanite to run with conda in an offline mode. If you are using conda without this option, the pipeline will build a conda environment on the fly prior to the its execution. Building a conda environment can sometimes be slow, as it downloads dependencies from the internet, so it may make sense to build it once and re-use it. This will also allow you to use conda/mamba in an offline mode. If you  have already built a named conda environment with the supplied yaml file, then you can directly use it with this option. Please provide the name of the conda environment that was specifically built for the nanite pipeline. 
>
> To create a reusable conda/mamba environment with the name `nanite`, please run the following mamba command: 
> ```bash
> # Creates a reusable conda
> # environment called nanite
> mamba env create -f workflow/envs/nanite.yaml.
> ```

> ***Example:*** `--conda-env-name nanite`

### 2.4 Miscellaneous options  
Each of the following arguments are optional, and do not need to be provided. 

  `-h, --help`            
> **Display Help.**  
> *type: boolean flag*
> 
> Shows command's synopsis, help message, and an example command
> 
> ***Example:*** `--help`

## 3. Example
```bash 
# Step 1.) Grab an interactive node,
# do not run on head node!
srun -N 1 -n 1 --time=1:00:00 --mem=8gb  --cpus-per-task=2 --pty bash
module purge
module load singularity snakemake

# Step 2A.) Dry-run the pipeline
./nanite run --input .tests/*.fastq.gz \
             --output /data/$USER/output \
             --mode slurm \
             --dry-run

# Step 2B.) Run the nanite pipeline
# The slurm mode will submit jobs to 
# the cluster. It is recommended running 
# the pipeline in this mode.
./nanite run --input .tests/*.fastq.gz \
             --output /data/$USER/output \
             --mode slurm
```