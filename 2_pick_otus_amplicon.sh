outdir=(your directory here)
usearchparams=/raid1/home/micro/klingesj/grace/CGRB_Scripts/otus_params.txt

## enter the qiime1.9 conda environment
source ~/.bashrc
source activate qiime1

##pick 97% OTUs as a link to previous analysis methods and data. Use the open reference pipeline so previously identified OTUs will share names with our dataset. GreenGenes is the default reference database, but this can be changed with "-r" (the taxonomy assignment database has to be separately specified in the parameters file). This workflow script also assigns taxonomy using RDP, aligns sequences to the reference, filters OTUs that do not successfully align, builds a de novo phylogeny, and filters singletons.
identify_chimeric_seqs.py -i ${outdir}/seqs.fna -m usearch61 -o ${outdir}/usearch_checked_chimeras/ -r /raid1/home/micro/klingesj/labhome/databases/gg_13_8_otus/rep_set/97_otus.fasta --threads 5

filter_fasta.py -f ${outdir}/seqs.fna -o ${outdir}/chimera_filtered.fna -s ${outdir}/usearch_checked_chimeras/chimeras.txt -n

pick_open_reference_otus.py -i ${outdir}/chimera_filtered.fna -o ${outdir}/otus_open_ref_usearch/ -r /nfs1/MICRO/Thurber_Lab/local/bin/miniconda3/envs/qiime1/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta -m usearch61 -f -p ${usearchparams} -aO 5