#!/usr/bin/ruby

# locate cox pathway genes existence in GEO datasets & count their existence
# USAGE: for i in results/*.csv;do (echo $i;./find_genes.rb data/COX_pathway_genesids.csv $i);done

require 'rubygems'
require 'fastercsv'

cox_pathway_genes_file = ARGV[0]
infile = ARGV[1]

filename = infile.split("/")[1].split(".")[0]
found_genes_output_file = "results/found_genes/#{filename}_found_genes.csv"

# read cox pathway genes
cox_genes = {}
FasterCSV.foreach(cox_pathway_genes_file) do |gene|
	cox_genes[gene.to_s] = nil
end

# find COX genes through the probes and count them
gene_expressions = Hash.new { |h,k| h[k] = [] }
genes_appearance = {}
FasterCSV.foreach(infile) do |row|
	row[1].each do |gene|
		gene_symbols = gene.split(" /// ")
		gene_symbols.each do |gene_symbol|
			if cox_genes.has_key?(gene_symbol)
				gene_expressions[gene_symbol.to_s + "|" + row[0]] << row
				# count COX genes appearance through the probes
				if !genes_appearance.has_key?(gene_symbol)
					genes_appearance[gene_symbol.to_s] = 1
				elsif genes_appearance.has_key?(gene_symbol)
					genes_appearance[gene_symbol.to_s] += 1
				end
			end
		end
	end
end

# print cox genes expressions
found_genes_output = File.open(found_genes_output_file, "w")
gene_expressions.sort.each do |g|
	gene_symbol = g[0].split("|")[0].to_s
	found_genes_output.puts gene_symbol + "," + g[1].join(",")
end
found_genes_output.close







