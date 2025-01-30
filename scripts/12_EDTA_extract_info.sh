#!/bin/bash

input_file="/data/users/lfernandez/assembly_course/EDTA_annotation/assembly.fasta.mod.EDTA.raw/assembly.fasta.mod.LTR.intact.gff3"
output_file="/data/users/lfernandez/assembly_course/EDTA_annotation/ltr_percent_identity.txt"


# Extract the full Name and ltr_identity (numeric value) and ensure uniqueness
grep "Name=" "$input_file" | \
awk -F"\t" '{
    name=""; ltr="";
    split($9, attributes, ";");  # Split attributes by semicolons
    for (i in attributes) {
        if (attributes[i] ~ /Name=/) {
            # Extract the full Name (before and after the colon)
            split(attributes[i], name_part, /=/);
            name = name_part[2];
        }
        if (attributes[i] ~ /ltr_identity=/) {
            # Extract ltr_identity value
            split(attributes[i], ltr_part, /=/);
            ltr = ltr_part[2];
        }
    }
    if (name != "" && ltr != "") {
        print name, ltr;
    }
}' | \
uniq > "$output_file"



# Add header to the output file
sed -i '1iName\tltr_identity' "$output_file"

# Notify user
echo "Percent identity values have been written to $output_file"