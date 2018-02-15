source ~/.bashrc

source activate qiime1

##summarize BIOM file as text
biom summarize-table -i /Users/graceklinges/Dropbox/tara_preliminary_analysis/otu_table_mc2_w_tax.biom -o /Users/graceklinges/Dropbox/tara_preliminary_analysis/otu_table_mc2_w_tax_summary.txt

##This script produces taxonomy summary plots, and a summarized OTU table if a map is supplied (pass -c to summarize table, -m to provide mapping file, -s to sort alphabetically)
summarize_taxa_through_plots.py -i /Users/graceklinges/Dropbox/tara_preliminary_analysis/otu_table_mc2_w_tax.biom -o /Users/graceklinges/Dropbox/tara_preliminary_analysis/taxa_summaries -s

##This script will perform beta diversity, principal coordinate analysis, and generate a preferences file along with 3D PCoA Plots.
## -i = The input biom table [REQUIRED]
## -m = Path to the mapping file [REQUIRED]
## -o = The output directory [REQUIRED]
## -t = Path to the tree file [REQUIRED for phylogenetic measures]
## -e = Depth of coverage for even sampling
## -p = Path to the parameter file, which specifies changes to the default behavior. 
beta_diversity_through_plots.py -i /Users/graceklinges/Dropbox/tara_preliminary_analysis/otu_table_mc2_w_tax.biom -o /Users/graceklinges/Dropbox/tara_preliminary_analysis/beta_div -e 14437 -p /Users/graceklinges/Dropbox/tara_preliminary_analysis/params.txt -m /Users/graceklinges/Dropbox/tara_preliminary_analysis/map.txt -t /Users/graceklinges/Dropbox/tara_preliminary_analysis/rep_set.tre
## e = 14437 = rarefaction based on lowest read count

##Filter corals from OTU table:
filter_samples_from_otu_table.py -i otu_table.biom -o otu_table_control_only.biom -m map.txt {add filter}
## -s 'organism:coral' (filter just for corals)
## -s 'organism:*,!coral' (removes corals)

##Filter OTUs with less than 100 hits from OTU table: 
filter_otus_from_otu_table.py -i /Users/graceklinges/Dropbox/tara_preliminary_analysis/otu_table_mc2_w_tax.biom -o /Users/graceklinges/Dropbox/tara_preliminary_analysis/filtered_min_100.biom -n 100

biom summarize-table -i /Users/graceklinges/Dropbox/tara_preliminary_analysis/filtered_min_100.biom -o /Users/graceklinges/Dropbox/tara_preliminary_analysis/filtered_min_100_summary.txt

beta_diversity_through_plots.py -i /Users/graceklinges/Dropbox/tara_preliminary_analysis/filtered_min_100.biom -o /Users/graceklinges/Dropbox/tara_preliminary_analysis/beta_div_filtered_min_100 -e 7944 -p /Users/graceklinges/Dropbox/tara_preliminary_analysis/params.txt -m /Users/graceklinges/Dropbox/tara_preliminary_analysis/map.txt -t /Users/graceklinges/Dropbox/tara_preliminary_analysis/rep_set.tre
##7944 = rarefaction based on lowest read count

summarize_taxa_through_plots.py -i /Users/graceklinges/Dropbox/tara_preliminary_analysis/filtered_min_100.biom -o /Users/graceklinges/Dropbox/tara_preliminary_analysis/taxa_summaries_filtered_min_100

##alpha diversity
##use -m chao1 for simple alpha diversity
##use -m PD_whole_tree for phylogenetic alpha diversity (must provide tree as -t)
alpha_diversity.py -i /Users/graceklinges/Dropbox/tara_secondary_analysis/otu_table_mc2_w_tax.biom -o /Users/graceklinges/Dropbox/tara_secondary_analysis/alpha_div/chao1.txt -m chao1 -t /Users/graceklinges/Dropbox/tara_secondary_analysis/rep_set.tre 

##compare categories (run for total, corals, filtered min 100)The sample groupings are determined by the -c option, based on the mapping file (-m). 
compare_categories.py -i /Users/graceklinges/Desktop/Tara/beta_div_corals/ -o /Users/graceklinges/Desktop/Tara/beta_div_corals --method adonis -m /Users/graceklinges/Desktop/Tara/map.txt -c ryan_species 
##run --method adonis partitions a distance matrix among sources of variation in order to describe the strength and significance that a categorical or continuous variable has in determining variation of distances.
##run --method permdisp determines whether the variances of groups of samples are significantly different

##This script is used to compare OTU frequencies in sample groups and to ascertain whether or not there are statistically significant differences between the OTU abundance in the different sample groups. The script will compare each OTU based on the passed sample groupings to see if it is differentially represented. The sample groupings are determined by the -c option, based on the mapping file (-m). 
##Input .biom rarefied OTU table. Default method is kruskall wallis.
group_significance.py -i /Users/graceklinges/Dropbox/tara_preliminary_analysis/beta_div/otu_table_mc2_w_tax_even14437.biom -o /Users/graceklinges/Dropbox/tara_preliminary_analysis/beta_div/group_sig.tsv -m /Users/graceklinges/Dropbox/tara_preliminary_analysis/map.txt -c ryan_species

