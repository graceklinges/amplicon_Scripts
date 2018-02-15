source ~/.bashrc

source activate qiime1

filter_otus_from_otu_table.py -i /nfs1/MICRO/Thurber_Lab/grace/20170104_TaraPrelim16S/otus_swarm/otu_table.biom -o /nfs1/MICRO/Thurber_Lab/grace/20170104_TaraPrelim16S/otus_swarm/otu_table.biom_mc2_no_pynast_failures -e /nfs1/MICRO/Thurber_Lab/grace/20170104_TaraPrelim16S/otus_swarm/pynast_aligned_seqs/chimera_filtered_rep_set_failures.fasta -n 2

biom add-metadata -i /nfs1/MICRO/Thurber_Lab/grace/20170104_TaraPrelim16S/otus_swarm/otu_table.biom_mc2_no_pynast_failures -o /nfs1/MICRO/Thurber_Lab/grace/20170104_TaraPrelim16S/otus_swarm/otu_table.biom_mc2_no_pynast_failures_w_tax --observation-metadata-fp /nfs1/MICRO/Thurber_Lab/grace/20170104_TaraPrelim16S/otus_swarm/uclust_assigned_taxonomy/chimera_filtered_rep_set_tax_assignments.txt --sc-separated taxonomy --observation-header 'otu,taxonomy'
