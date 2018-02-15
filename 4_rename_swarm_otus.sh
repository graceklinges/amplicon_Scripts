##this script will compare the OTUs identified by swarm to a reference database so the names match
indir=(your directory here)
source ~/.bashrc

source activate qiime1

parallel_pick_otus_uclust_ref.py -i ${indir}/otus_swarm/rep_set/chimera_filtered_rep_set.fasta -o ${indir}/otus_swarm/renamed -s 1.0 -r /nfs1/MICRO/Thurber_Lab/local/bin/miniconda3/envs/qiime1/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta -O 4