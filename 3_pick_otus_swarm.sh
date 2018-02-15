outdir=/raid1/home/micro/klingesj/grace/beccatest
nthreads=5
swarmparams=/raid1/home/micro/klingesj/grace/CGRB_Scripts/swarm_otus_params.txt

## enter the qiime1.9 conda environment
source ~/.bashrc
source activate qiime1


## dereplicate sequences
vsearch --derep_fulllength ${outdir}/chimera_filtered.fna --output ${outdir}/seqs_derep.fasta --uc seqs_derep.uc --relabel_sha1 --relabel_keep --sizeout --threads ${nthreads} --fasta_width 0

## pick Swarm OTUs for high-resolution community matrix. This workflow script also assigns taxonomy using RDP, aligns sequences to the reference, and builds a de novo phylogeny.
pick_de_novo_otus.py -i ${outdir}/seqs_derep.fasta -o ${outdir}/otus_swarm/ -p ${swarmparams} -aO ${nthreads}

## since the de novo OTU pipeline does not remove singletons, do this manually
filter_otus_from_otu_table.py -i ${outdir}/otus_swarm/otu_table.biom -o ${outdir}/otus_swarm/otu_table_mc2_wtax.biom -n 2

