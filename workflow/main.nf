// Declare syntax version
nextflow.enable.dsl=2

process FREEBAYES {

    container = "${projectDir}/../singularity-images/depot.galaxyproject.org-singularity-freebayes-1.3.6--hbfe0e7f_2.img"

    input:
    path fasta
    path fasta_index
    path cram 
    path cram_index
    val prefix

    output:
    path "*vcf.gz"

    script:
    """
    freebayes \\
        -f $fasta \\
        --min-alternate-fraction 0.1 --min-mapping-quality 1 \\
        $cram > ${prefix}.vcf
    bgzip ${prefix}.vcf
    cp ${prefix}.vcf.gz ${launchDir}/${params.outdir}/
    """
}

workflow{
    fasta       = Channel.of(params.fasta)
    fasta_index = Channel.of(params.fasta_index)
    cram        = Channel.of(params.cram)
    cram_index  = Channel.of(params.cram_index)
    prefix      = Channel.of(params.prefix)
    FREEBAYES(fasta, fasta_index, cram, cram_index, prefix)
}

