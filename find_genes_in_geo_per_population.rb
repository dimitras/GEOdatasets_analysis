#!/usr/bin/ruby

# locate cox pathway genes existence in GEO datasets

# USAGE: for i in results/*.csv;do (echo $i;./find_genes_in_geo_per_population.rb results/eqtl_results_sets/CV_plots/mix_cox_and_housekeeping_genes.csv $i results/eqtl_results_sets/CV_plots/ids_per_hapmap_group/GM_ids_in_CEU.txt);done

require 'rubygems'
require 'fastercsv'

cox_pathway_genes_file = ARGV[0]
infile = ARGV[1]
grouped_gm_ids_file = ARGV[2]

filename = infile.split("/")[1].split(".")[0]
found_genes_output_file = "results/eqtl_results_sets/CV_plots/mixed_genes_found_in_geo_groups/mixed_genes_found_in_#{filename}.csv"

group = grouped_gm_ids_file.split("/")[4].split("_")[3].split(".")[0]
found_genes_in_group_output_file = "results/eqtl_results_sets/CV_plots/mixed_genes_found_in_geo_groups/mixed_genes_found_in_#{filename}_of_#{group}.csv"

# read cox pathway genes
cox_genes = {}
FasterCSV.foreach(cox_pathway_genes_file) do |gene|
	cox_genes[gene.to_s] = nil
end

# find COX genes through the probes and count them
gene_expressions = Hash.new { |h,k| h[k] = [] }
genes_appearance = {}
header = nil
ids_string = ""
FasterCSV.foreach(infile) do |row|
	if header == nil
		row.each do |cell|
			cell.sub!(",","_")
		end 
		header = row.join(",")
	end
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
found_genes_output.puts " ," + header
gene_expressions.sort.each do |g|
	gene_symbol = g[0].split("|")[0].to_s
	found_genes_output.puts gene_symbol + "," + g[1].join(",")
end
found_genes_output.close

puts found_genes_output_file
# if !exist?(found_genes_output_file)
# 	puts "output error"
# 	break
# end

# read gm ids for all groups
grouped_gm_ids = {}
File.open(grouped_gm_ids_file).each_line do |id|
	grouped_gm_ids[id.chomp!.to_s] = nil
end

# find GM ids which are grouped by hapmap populations, in the mixed genes found per geo group
genes_per_group_output = File.open(found_genes_in_group_output_file, "w")
header = ""
index_array = []
FasterCSV.foreach(found_genes_output_file) do |row|
	if header.empty?
		row.each_with_index do |cell,index|
			if !cell.nil?
				if grouped_gm_ids.has_key?(cell.split('_')[0].to_s)
					header << cell + ","
					index_array << index
				end
			end
		end
		genes_per_group_output.puts " , , , , , , ,#{header}"
	else
		selected_columns = []
		selected_columns << row[0..6]
		index_array.each do |i|
			selected_columns << row[i]
		end
		genes_per_group_output.puts selected_columns.join(',')
	end
end








