# Data processing rules
rule kronatools:
    """
    Reporting step to summarize results with kronatools.
    @Input:
        SAM file (scatter)
    @Output:
        HTML Krona report
    """
    input:
        sam = join(workpath, "{name}", "bams", "{name}.sam"),
    output:
        taxa = join(workpath, "{name}", "reports", "{name}.krona"),
        html = join(workpath, "{name}", "reports", "{name}_classification.html"),
    params:
        rname  = 'kronatools',
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
