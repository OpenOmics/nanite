# Data processing rules
rule minimap2:
    """
    Data-processing step to align reads against NCBI Viral database.
    @Input:
        Quality filtered FastQ file (scatter)
    @Output:
        SAM file
    """
    input:
        fq  = join(workpath, "{name}", "fastqs", "{name}.filtered.fastq.gz"),
    output:
        sam = join(workpath, "{name}", "bams", "{name}.sam"),
    params:
        rname  = 'minimap2',
        viral_fa  = config['references']['ncbi_viral_fa'],
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['nanite'], use_singularity)
    shell: 
        """
        # Align against entire NCBI Viral database,
        # remove chimeric/supplementary reads
        minimap2 \\
            -ax map-ont \\
            --secondary=no \\
            --sam-hit-only \\
            {params.viral_fa} \\
            {input.fq} \\
            | samtools view -h -F 2048,2064 \\
        > {output.sam}
        """
