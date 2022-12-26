rule mutect2:
    # writes swarm file to call by contig using Mutect2
    input:
        bams=expand("mapped-reads/star/{sample}.recal.bam", sample=config["samples"]),
        ref=config["reference"]["assembly"]
    output:
        f"calls/calling-scripts/{config['sample_name']}_mutect2.swarm"
    params:
        **config["params"]["gatk"]["mutect2"]
    shell:
        "python3 scripts/split-contigs.py {params.samplename} "
	"{input.ref} {input.bams} {params.normal} {params.germline} {params.pon} {output} {params.intervals}" #split-contigs.py 

rule call_by_contig:
    input:
        f"calls/calling-scripts/{config['sample_name']}_mutect2.swarm"
    output:
        expand("calls/mutect2/{sample}/{sample}_{contigs}.vcf.gz{file}",
            sample=config["sample_name"],
            contigs=config["params"]["gatk"]["mutect2"]["intervals"],
            file={"",".stats"})
    threads:
        config["params"]["gatk"]["mutect2"]["threads"]
    params:
        **config["params"]["gatk"]["mutect2"]
    shell:
        #use python script to generate what splits the calling step to multiple contigs
        """
	swarm --module GATK --partition norm -t {threads} -g 8 -b 5 --time=8:00:00 --gres=lscratch:16 {input}
	sleep 600
	while true
	do
    		numfiles=$(ls calls/mutect2/{params.samplename}/*vcf.gz.stats | wc -l)
    		echo "Number: $numfiles"
    		if [[ $numfiles -eq 25 ]]; then
        		sleep 500
			break
    		else
    			sleep 60
		fi
	done
	"""
