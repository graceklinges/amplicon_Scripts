##use this script if swarm's standard tree building step fails

source ~/.bashrc

source activate qiime1

make_phylogeny.py -i /nfs1/MICRO/Thurber_Lab/grace/20170104_TaraPrelim16S/otus_swarm//pynast_aligned_seqs/chimera_filtered_rep_set_aligned_pfiltered.fasta -o /nfs1/MICRO/Thurber_Lab/grace/20170104_TaraPrelim16S/otus_swarm//rep_set.tre 