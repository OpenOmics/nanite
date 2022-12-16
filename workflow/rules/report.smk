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
        sam = join(workpath, "bams", "{name}.sam"),
    output:
        taxa = join(workpath, "reports", "{name}.krona"),
        html = join(workpath, "reports", "{name}_classification.html"),
    params:
        rname  = 'kronatools',
        krona_ref  = config['references']['kronatools'],
    conda: config['conda']['nanite']
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