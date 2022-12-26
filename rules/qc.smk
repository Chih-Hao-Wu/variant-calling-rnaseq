rule trimgalore:
    input:
        "/data/CDSLSahinalp/immunotherapy-WES/Pitzalis/PRJEB23131/{sample}_R1.fastq.gz",
        "/data/CDSLSahinalp/immunotherapy-WES/Pitzalis/PRJEB23131/{sample}_R2.fastq.gz"
    output:
        "quality-trimmed-fastq/{sample}_R1_val_1.fq.gz",
        "quality-trimmed-fastq/{sample}_R2_val_2.fq.gz"
    params:
        *config["params"]["trimgalore"]
    shell:
        "trim_galore --paired {params} {input} -o quality-trimmed-fastq/"
