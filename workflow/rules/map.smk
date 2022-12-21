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
    conda: depending(join(workpath, config['conda']['nanite']), use_conda)
    container: depending(config['images']['nanite'], use_singularity)
    shell: 
        """
        # Align against entire NCBI Viral database 
        minimap2 \\
            -ax map-ont \\
            --secondary=no \\
            --sam-hit-only \\
            {params.viral_fa} \\
            {input.fq} \\
        > {output.sam}
        """
