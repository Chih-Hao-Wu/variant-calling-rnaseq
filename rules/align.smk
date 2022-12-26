rule star_map:
    input:
        reads=[
            "quality-trimmed-fastq/{sample}_R1_val_1.fq.gz",
            "quality-trimmed-fastq/{sample}_R2_val_2.fq.gz"
        ],
        refdir=config["reference"]["directory"]
    output:
        "mapped-reads/star/{sample, \w+}Aligned.sortedByCoord.out.bam"
    threads: 
        config["params"]["star"]["threads"]
    params:
        *config["params"]["star"]["other"]
    shell:
        "STAR --runThreadN {threads} --genomeDir {input.refdir} "
        "--readFilesIn {input.reads} {params} --outFileNamePrefix mapped-reads/star/{wildcards.sample}"
