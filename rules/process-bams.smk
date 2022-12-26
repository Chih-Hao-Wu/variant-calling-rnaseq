rule add_or_replace_read_groups:
    input:
        "mapped-reads/star/{sample}Aligned.sortedByCoord.out.bam"
    output:
        "mapped-reads/star/{sample, \w+}.rg.bam"
    params:
        *config["params"]["addorreplacereadgroups"]
    shell:
        "java -jar $PICARDJARPATH/picard.jar AddOrReplaceReadGroups "
        "I={input} O={output} {params} RGSM={wildcards.sample}"

rule mark_duplicates:
    input:
        "mapped-reads/star/{sample}.rg.bam"
    output:
        "mapped-reads/star/{sample, \w+}.markedduplicates.bam"
    threads:
        config["params"]["picard"]["markduplicates"]["threads"]
    shell:
        "java -Xmx32g -XX:ParallelGCThreads={threads} -jar $PICARDJARPATH/picard.jar MarkDuplicates "
        "I={input} O={output} M=mapped-reads/star/{wildcards.sample}.metrics.bam"

rule split_n_cigar_reads:
    input:
        bam="mapped-reads/star/{sample}.markedduplicates.bam",
        ref=config["reference"]["assembly"]
    output:
        "mapped-reads/star/{sample, \w+}.splitreads.bam"
    shell:
        "gatk SplitNCigarReads -R {input.ref} -I {input.bam} -O {output}"

rule bqsr_recalibrate:
    input:
        bam="mapped-reads/star/{sample}.splitreads.bam",
        ref=config["reference"]["assembly"]
    output:
        "mapped-reads/star/{sample}.recal.table"
    params:
        *config["params"]["gatk"]["baserecalibrator"]
    shell:
        "gatk BaseRecalibrator -I {input.bam} -R {input.ref} {params} -O {output}"

rule bqsr_apply:
    input:
        bam="mapped-reads/star/{sample}.splitreads.bam",
        table="mapped-reads/star/{sample}.recal.table",
        ref=config["reference"]["assembly"]
    output:
        "mapped-reads/star/{sample}.recal.bam"
    shell:
        "gatk ApplyBQSR -R {input.ref} -I {input.bam} "
        "--bqsr-recal-file {input.table} -O {output}"
