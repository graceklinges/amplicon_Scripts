##filter_alignment.py -i swarm_otus/pynast_aligned_seqs/rep_set_aligned.fasta -s -o swarm_otus/pynast_aligned_seqs/rep_set_aligned_filtered_no_lanemask/

filter_tree.py -i /macqiime/greengenes/gg_13_8_otus/trees/97_otus_unannotated.tree -o gg_13_8_97_otus_filtered.tre -f swarm_otus/pynast_aligned_seqs/rep_set_aligned_filtered_no_lanemask/rep_set_aligned_pfiltered.fasta

#following instructions from http://meta.microbesonline.org/fasttree/constrained.html, I created constraints for FastTree using the greengenes reference tree:

perl TreeToConstraints.pl < gg_13_8_97_otus_filtered.tre > gg_13_8_97_otus_fasttree_constraints.txt

#and then ran FastTree on the server using these constraints on the pynast rep_set alignment.

export OMP_NUM_THREADS=10

FastTreeMP -constraints gg_13_8_97_otus_fasttree_constraints.txt -fastest -nt < swarm_otus/pynast_aligned_seqs/rep_set_aligned_filtered_no_lanemask/rep_set_aligned_pfiltered.fasta > gg_constrained_rep_set_fastttree.tre
