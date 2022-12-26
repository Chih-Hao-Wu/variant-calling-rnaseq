rule bcftools_concat:
    input:
        expand("calls/mutect2/{sample}/{sample}_{contigs}.vcf.gz",
            sample=config["sample_name"],
            contigs=config["params"]["gatk"]["mutect2"]["intervals"])
    output:
        f"calls/mutect2/{config['sample_name']}/{config['sample_name']}.vcf.gz"
    params:
        *config["params"]["bcftools"]
    shell:
        # use python script to generate what splits the calling step to multiple contigs
        "bcftools concat {params} -o {output} {input}"

rule merge_mutect_stats:
    input:
        expand("calls/mutect2/{sample}/{sample}_{contigs}.vcf.gz.stats",
            sample=config["sample_name"],
            contigs=config["params"]["gatk"]["mutect2"]["intervals"])
    output:
        f"calls/mutect2/{config['sample_name']}/{config['sample_name']}.vcf.gz.stats"
    shell:
        # use python script to generate what splits the calling step to multiple contigs
        "gatk MergeMutectStats --stats {input[0]} --stats {input[1]} --stats {input[2]} --stats {input[3]} --stats {input[4]} --stats {input[5]} --stats {input[6]} --stats {input[7]} --stats {input[8]} --stats {input[9]} --stats {input[10]} --stats {input[11]} --stats {input[12]} --stats {input[13]} --stats {input[14]} --stats {input[15]} --stats {input[16]} --stats {input[17]} --stats {input[18]} --stats {input[19]} --stats {input[20]} --stats {input[21]} --stats {input[22]} -O {output}"
        
rule index_calls:
    input:
        f"calls/mutect2/{config['sample_name']}/{config['sample_name']}.vcf.gz"
    output:
        f"calls/mutect2/{config['sample_name']}/{config['sample_name']}.vcf.gz.tbi"
    shell:
        # use python script to generate what splits the calling step to multiple contigs
        "gatk IndexFeatureFile -I {input}"
