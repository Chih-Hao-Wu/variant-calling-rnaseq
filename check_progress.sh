#!/bin/bash

ls calls/mutect2/*/*.vcf.gz | grep -v "chr" | cut -d '/' -f3 > .progress/mutect2_calls.txt
ls -l filter/filtered_case-*.gz | awk -F 'filtered_' '{print $2}' | cut -d '.' -f1 > .progress/annotated_calls.txt

num_complete=$(wc -l < .progress/mutect2_calls.txt)
num_annotated=$(wc -l < .progress/annotated_calls.txt)

printf "Number samples with completed calls: $num_complete \n"
printf "Fraction samples with annotated calls: $num_annotated/$num_complete \n"
