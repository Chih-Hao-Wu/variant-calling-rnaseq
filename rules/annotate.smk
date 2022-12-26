rule functotator:
    input:
        vcf=f"filter/filtered_{config['sample_name']}.vcf.gz",
        ref=config["reference"]["assembly"],
        table=f"filter/contamination_{config['sample_name']}.table"
    output:
        f"filter/variants_{config['sample_name']}.funcotated.vcf"
    shell:
        "gatk Funcotator "
        "--variant {input.vcf} -reference {input.ref} --ref-version hg38 --data-sources-path /data/CDSLSahinalp/immunotherapy-WES/funcotator_dataSources.v1.7.20200521s "
        "--output {output} --output-file-format VCF"
