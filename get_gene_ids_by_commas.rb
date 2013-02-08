# USAGE: ruby get_gene_ids_by_commas.rb data/extended_cox_pathway_genes_ArachAcidKegg_7Feb.csv

# quickly get the geneids seperated by commas to put it as argument in ncbi efetch

require 'rubygems'
require 'fastercsv'

cox_genes_file = ARGV[0]

# parse cox pathway genes file into a hash
cox_genes = {}
FasterCSV.foreach(cox_genes_file) do |gene|
	if gene[5] != "NCBI Entrez gene ID"
		cox_genes[gene[5]] = nil
	end
end

puts cox_genes.keys.join(",")