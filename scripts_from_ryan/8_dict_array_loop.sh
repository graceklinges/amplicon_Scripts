source ~/.bashrc

source activate qiime1

## NR==FNR means for first file (all times record number is equal to the total record number) create an array named 'dict' with keys in the form ">name", where name is the existing sequence identifier as pulled from the second column of the otu map, and a value for that key that corresponds to the desired new name, as pulled from the first column of the otu map. after the first file is parsed and entered into the array, start processing the second file, and if the first item is equal to any of the keys in the array, substitute the ">" with the new name. the "1" at the end means, for every line regardless of its presence in the array, print the line
awk 'NR==FNR {dict[">"$2]=$1; next} $1 in dict {sub(/>/,">"dict[$1]"\t",$1)} 1' /raid1/home/micro/klingesj/grace/20170104_TaraPrelim16S/otus_swarm/renamed/renamed_otus.txt /raid1/home/micro/klingesj/grace/20170104_TaraPrelim16S/otus_swarm/rep_set/chimera_filtered_rep_set.fasta > swarm_otus/renamed/swarm_rep_set_newnames.fna

biom convert --table-type 'OTU table' --header-key 'taxonomy' --to-tsv -i /raid1/home/micro/klingesj/grace/20170104_TaraPrelim16S/otus_swarm/otu_table_mc2_no_pynast_failures_w_tax.biom -o /raid1/home/micro/klingesj/grace/20170104_TaraPrelim16S/otus_swarm/swarm_otu_table.txt

awk 'NR==FNR {dict[">"$2]=$1; next} ">"$1 in dict {$1 = dict[">"$1]} 1' /raid1/home/micro/klingesj/grace/20170104_TaraPrelim16S/otus_swarm/renamed/renamed_otus.txt /raid1/home/micro/klingesj/grace/20170104_TaraPrelim16S/otus_swarm/swarm_otu_table.txt > /raid1/home/micro/klingesj/grace/20170104_TaraPrelim16S/otus_swarm/swarm_otu_table_newnames.txt

biom convert --table-type 'OTU table' --to-hdf5 --process-obs-metadata taxonomy -i /raid1/home/micro/klingesj/grace/20170104_TaraPrelim16S/otus_swarm/swarm_otu_table_newnames.txt -o /raid1/home/micro/klingesj/grace/20170104_TaraPrelim16S/otus_swarm/swarm_otu_table_newnames.biom
