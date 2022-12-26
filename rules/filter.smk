rule getpileupsummaries_normal:
    # writes swarm file to call by contig using Mutect2
    input:
        bams=expand("mapped-reads/star/{sample}.recal.bam", sample=config["samples"][0]),
        vcf="/data/CDSLSahinalp/immunotherapy-WES/GRCh38/small_exac_common_3.hg38.vcf.gz"
    output:
        f"filter/normal-pileup_{config['sample_name']}.table"
    shell:
        "gatk GetPileupSummaries"
        " -I {input.bams} -V {input.vcf} -L {input.vcf} -O {output}"

rule getpileupsummaries_tumour:
    # writes swarm file to call by contig using Mutect2
    input:
        bams=expand("mapped-reads/star/{sample}.recal.bam", sample=config["samples"][1]),
        vcf="/data/CDSLSahinalp/immunotherapy-WES/GRCh38/small_exac_common_3.hg38.vcf.gz"
    output:
        f"filter/tumour-pileup_{config['sample_name']}.table"
    shell:
        "gatk GetPileupSummaries"
        " -I {input.bams} -V {input.vcf} -L {input.vcf} -O {output}"

rule calculatecontamination:
    # writes swarm file to call by contig using Mutect2
    input:
        bams=expand("filter/{type}-pileup_{sample}.table", type=["normal", "tumour"], sample=config["sample_name"]),
    output:
        f"filter/contamination_{config['sample_name']}.table"
    shell:
        "gatk CalculateContamination"
        " -I {input.bams[1]} -matched {input.bams[0]} -O {output}"

rule filtermutectcalls:
    # writes swarm file to call by contig using Mutect2
    input:
        bams=f"calls/mutect2/{config['sample_name']}/{config['sample_name']}.vcf.gz",
        ref=config["reference"]["assembly"],
        table=f"filter/contamination_{config['sample_name']}.table"
    output:
        f"filter/filtered_{config['sample_name']}.vcf.gz"
    shell:
        "gatk FilterMutectCalls "
        "-R {input.ref} -V {input.bams} --contamination-table {input.table} --unique-alt-read-count 3 -O {output}"
