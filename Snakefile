# update config for each matched tumour-normal pair, then submit
#configfile: "config.yaml"

##### load rules #####

include: "rules/qc.smk"
include: "rules/align.smk"
include: "rules/process-bams.smk"
include: "rules/mutation-call.smk"
include: "rules/process-calls.smk"
include: "rules/filter.smk"
include: "rules/annotate.smk"

##### target rules #####

rule all:
    input:
        f"filter/variants_{config['sample_name']}.funcotated.vcf"        
#f"filter/filtered_{config['sample_name']}.vcf.gz"        
#f"filter/contamination_{config['sample_name']}.table"
	 #f"filter/normal-pileup_{config['sample_name']}.table",
        #f"filter/tumour-pileup_{config['sample_name']}.table"
	#f"calls/mutect2/{config['sample_name']}/{config['sample_name']}.vcf.gz.stats",
       #f"calls/mutect2/{config['sample_name']}/{config['sample_name']}.vcf.gz.tbi"
