import sys
import re

def header_reader(file: str) -> list[str]:
    contigs = []

    with open (file) as fh:
        for line in fh:
 
            contig = re.search(r"(?<=contig=<ID=)\w+(\d+)*", line)
            
            if contig:
                contigs.append(contig.group(0))

            elif not line.startswith("##"):
                break

    # consider only 1-19, X, Y, M
    return contigs[:22]

def write_swarm(
    reference: str,
    normal_bam: str,
    tumour_bam: str,
    interval: str,
    normal: str,
    germline_resource: str,
    panel_of_normals: str,
    sample_name: str
    ) -> str:

    #TODO fix this
    swarm = f"""gatk --java-options \"-Xmx6g\" Mutect2
    -R {reference} 
    -I {normal_bam} -I {tumour_bam} 
    -L {interval}
    -normal {normal} 
    --germline-resource {germline_resource} 
    --panel-of-normals {panel_of_normals} 
    -O calls/mutect2/{sample_name}/{sample_name}_{interval}.vcf.gz"""

    return re.sub("\s+"," ",swarm)

def main():

    # TODO consider change to argparse
    _, sample, ref, bam1, bam2, normal, germline, pon, out = sys.argv[:9]
    intervals = sys.argv[9:]

    cmd = []
    #contigs = header_reader(bam1)
    contigs = intervals

    for interval in contigs:
        interval_calls = write_swarm(
            reference=ref,
            normal_bam=bam1,
            tumour_bam=bam2,
            interval=interval,
            normal=normal,
            germline_resource=germline,
            panel_of_normals=pon,
            sample_name=sample
            )
        cmd.append(interval_calls)
    
    swarm = "\n".join(cmd)

    with open(out, "w") as fh:
        fh.write(swarm)

if __name__ == "__main__":
    main()
