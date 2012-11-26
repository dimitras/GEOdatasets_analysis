# locate cox pathway genes existance in GEO datasets & count their existance
# USAGE: ruby find_genes.rb data/COX_pathway_genesids.csv

require 'rubygems'
require 'fastercsv'

cox_pathway_genes_file = ARGV[0]

Dir["results/*.csv"].each do |infile|
	filename = infile.split("/")[1].split(".")[0]
	puts filename
	gene_names = {}
	genes = []
	full_entries = Hash.new { |h,k| h[k] = [] }
	found_genes = Array.new
	FasterCSV.foreach(infile) do |row|
		# count dataset genes
		row[1].each do |gene|
			genes = gene.split(" /// ")
			genes.each do |g|
				if !gene_names.has_key?(g)
					gene_names[g.to_s] = 1
				elsif gene_names.has_key?(g)
					gene_names[g.to_s] += 1
				end
				full_entries[g.to_s] << row
			end
		end
	end

	# search for cox pathway genes
	found_genes_output = File.open("results/found_genes/#{filename}_found_genes.csv", "w")
	FasterCSV.foreach(cox_pathway_genes_file) do |gene|
		if gene_names.has_key?(gene.to_s)
			found_genes << [gene.to_s, gene_names[gene.to_s]]
			found_genes_output.puts '"' + full_entries[gene.to_s].join(",") + '"'
		end
	end
	found_genes_output.close

end





