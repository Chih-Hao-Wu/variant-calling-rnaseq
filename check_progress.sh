#!/bin/bash

# get sample names depending on whether the variants have been callled and then annotated
ls calls/mutect2/*/*.vcf.gz | grep -v "chr" | cut -d '/' -f3 > .progress/mutect2_calls.txt
ls -l filter/filtered_case-*.gz | awk -F 'filtered_' '{print $2}' | cut -d '.' -f1 > .progress/annotated_calls.txt

# get counts
num_complete=$(wc -l < .progress/mutect2_calls.txt)
num_annotated=$(wc -l < .progress/annotated_calls.txt)

# print counts to line
printf "Number samples with completed calls: $num_complete \n"
printf "Fraction samples with annotated calls: $num_annotated/$num_complete \n"

# find difference between annotated and called, return called, unannotated
diff -u .progress/mutect2_calls.txt .progress/annotated_calls.txt | grep '^-case' | sed 's/-//' > .progress/unannotated_calls.txt 
