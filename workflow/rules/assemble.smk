# Data processing rules,
# Assembles reads and recovers high-quality viral genomes.
rule viralflye:
    """
    Data-processing step to assemble and recover 
    potential viral genomes using Flye/viralFlye.
    @Input:
        Quality filtered FastQ file (scatter)
    @Output:
        SAM file of viralFlye assembly mapped to viral genomes
    """
    input:
        fq  = join(workpath, "{name}", "fastqs", "{name}.filtered.fastq.gz"),
    output:
        flye_asm      = join(workpath, "{name}", "assembly", "flye", "assembly.fasta"),
        viralflye_asm = join(workpath, "{name}", "assembly", "viralflye", "linears_viralFlye.fasta"),
        viralflye_sam = join(workpath, "{name}", "assembly", "bams", "{name}_viralflye.sam"),
    params:
        rname  = 'viralflye',
        flye_outdir      = join(workpath, "{name}", "assembly", "flye"),
        viralflye_outdir = join(workpath, "{name}", "assembly", "viralflye"),
        viral_fa  = config['references']['ncbi_viral_fa'],
        pfam_ref  = config['references']['viralflye_pfam_hmm'],
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['nanite'], use_singularity)
    shell: 
        """
        # Assemble reads using Flye
        flye \\
            --meta \\
            --nano-raw \\
            {input.fq} \\
            --out-dir {params.flye_outdir}
        # Recover viral genomes using viralFlye
        viralFlye.py \\
            --dir {params.flye_outdir} \\
            --hmm {params.pfam_ref} \\
            --reads {input.fq} \\
            --outdir {params.viralflye_outdir} \\
            --min_viral_length 1000 \\
            --completeness 0.25
        # Map viralFlye assembly to viral genomes
        minimap2 \\
            -ax map-ont \\
            --secondary=no \\
            --sam-hit-only \\
            {params.viral_fa} \\
            {output.viralflye_asm} \\
        > {output.viralflye_sam}
        """


# Runs kronatools to generate Krona plots of viralFlye assemblies.
rule viralflye_report:
    """
    Reporting step to summarize recovered viral genome results with kronatools.
    @Input:
         SAM file of viralFlye assembly mapped to viral genomes (scatter)
    @Output:
        HTML Krona report of viralFlye recovered viral genomes
    """
    input:
        sam = join(workpath, "{name}", "assembly", "bams", "{name}_viralflye.sam"),
    output:
        taxa = join(workpath, "{name}", "assembly", "reports", "{name}.krona"),
        html = join(workpath, "{name}", "assembly", "reports", "{name}_viralflye_classification.html"),
    params:
        rname  = 'flye_report',
        krona_ref  = config['references']['kronatools'],
    conda: depending(conda_yaml_or_named_env, use_conda)
    container: depending(config['images']['nanite'], use_singularity)
    shell: 
        """
        # Create Krona Taxonomy file 
        grep -v "^@" {input.sam} \\
            | awk -v OFS='\\t' '{{split($3,a,"_"); print $1,a[3]}}' \\
        > {output.taxa}
        # Create Krona Report
        ktImportTaxonomy \\
            -tax {params.krona_ref} \\
            -o {output.html} \\
            {output.taxa}
        """