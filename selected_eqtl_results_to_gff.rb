#!/usr/bin/ruby
# USAGE: ruby selected_eqtl_results_to_gff.rb data/eqtl_browser/sample_groups_for_studies.csv  data/COX_pathway_genesids.csv data/eqtl_browser/All.individual.tracks.gff.v3 7.0 results/eqtl_results_sets/selected_eqtl_result_sets_by_geneid_for_cox_genes.xlsx
# FOR EXTENDED GENES LIST: 
# ruby selected_eqtl_results_to_gff.rb data/eqtl_browser/sample_groups_for_studies.csv  data/extended_uniques_cox_pathway_geneids.csv data/eqtl_browser/All.individual.tracks.gff.v3 7.0 results/eqtl_results_sets/selected_eqtl_result_sets_by_geneid_for_extended_list.xlsx
# ruby selected_eqtl_results_to_gff.rb data/eqtl_browser/sample_groups_for_studies.csv  data/extended_uniques_cox_pathway_geneids.csv data/eqtl_browser/All.individual.tracks.gff.v3 0.0 results/eqtl_results_sets/selected_eqtl_result_sets_by_geneid_for_extended_list_nocutoff.xlsx
# Run for mixed genes list
# ruby selected_eqtl_results_to_gff.rb data/eqtl_browser/sample_groups_for_studies.csv  results/eqtl_results_sets/CV_plots/mix_cox_and_housekeeping_genes.csv data/eqtl_browser/All.individual.tracks.gff.v3 7.0 results/eqtl_results_sets/CV_plots/selected_eqtl_result_sets_by_geneid_for_mixed_genes.xlsx

# Parse the results sets from eqtl browser, get the results for our genes of interest by keeping only the studies included in the sample groups list, and the ones with score cutoff above 7. The sample groups list was filtered by keeping only the Tcells, LCLs and monocytes tissues. Add population and tissue in the output table.

require 'rubygems'
require 'fastercsv'
require 'axlsx'

# input files
sample_groups_file = ARGV[0]
cox_genes_file = ARGV[1]
eqtl_full_result_sets_file = ARGV[2]
score_cutoff = ARGV[3].to_f # recommended 7.0

# output file
selected_eqtl_result_sets_out = ARGV[4]


# parse sample groups file into a hash
studies_populations = {}
FasterCSV.foreach(sample_groups_file) do |row|
	if row.include?("STUDY")
		next
	end
	study = row.to_s.split(" ")[0].to_s
	studies_populations[study] = row
end
# puts "POPULATIONS:: \n #{studies_populations.inspect}"

# parse cox pathway genes file into a hash
cox_genes = {}
FasterCSV.foreach(cox_genes_file) do |gene|
	cox_genes[gene.to_s] = nil
end
# puts "GENES:: \n #{cox_genes.inspect}"

# parse eqtl full results sets file and get the selected genes' entries into a hash
selected_eqtl_result_sets_hash = Hash.new { |h,k| h[k] = [] }
gff_genes = {} # to count unique genes in gff
File.open(eqtl_full_result_sets_file).each_line do |line|
	if line.include?("Alias") 
		genename = line.split("Alias ")[1].split(" ;")[0].to_s
	elsif line.include?("eQTL for")
		genename = line.split("eQTL for ")[1].split("\";")[0].to_s
	end
	gff_genes[genename] = nil
	study = line.split(" ")[1].to_s
	if study =~ /^(\D+)((\d+_\w+)|(_\w+))$/
		study = $1
	else
		study
	end
	score = line.split("\t")[5].to_f
	if cox_genes.has_key?(genename)
		if studies_populations.has_key?(study)
			if score >= score_cutoff
				selected_eqtl_result_sets_hash[genename] << line
			end
		end	
	end
end
# puts "RESULTS:: \n #{selected_eqtl_result_sets_hash.keys}"
# puts gff_genes.keys.length

# to get the missing genes
missed_genes = {}
cox_genes.each_key do |gene|
	if !selected_eqtl_result_sets_hash.has_key?(gene)
		missed_genes[gene] = nil
	end
end		
# puts "MISSED GENES:: \n #{missed_genes.keys.join("\n")}"

# initialize output arg
selected_eqtl_result_sets_table = Axlsx::Package.new
wb = selected_eqtl_result_sets_table.workbook

# add some styles to the worksheet
header = wb.styles.add_style :b => true, :alignment => { :horizontal => :left }
alignment = wb.styles.add_style :alignment => { :horizontal => :left }

# create sheet with the results for our genes of interest
wb.add_worksheet(:name => "selected eQTL result sets") do |sheet|
	sheet.add_row ["GENENAME", "TISSUE", "POPULATION", "CHR", "STUDY", "STUDY_QTL", "BP", "STOP_POS", "LOG", "P", "STRAND", "SNP", "ACT", "NOTES"], :style=>header
	selected_eqtl_result_sets_hash.each do |gene, entries|
		entries.each do |entry|
			(chrom, study, study_qtl, start_pos, stop_pos, score, strand, num, notes) = entry.split("\t")
			if study =~ /^(\D+)((\d+_\w+)|(_\w+))$/
				study = $1
			else
				study
			end
			if (notes =~ /\"(rs\d+) an e[Qq][Tt][Ll] for/) || (notes =~ /\"(rs\d+) a transcript/) || (notes =~ /\"(rs\d+) an exon-QTL/)
				snp = $1
			else
				snp = ""
			end
			if (notes =~ /Note \"[Aa]cts in (cis)/) || (notes =~ /Note \"[Aa]cts in (trans)/)
				act = $1
			else
				act = ""
			end
			if studies_populations.include?(study)
				row = sheet.add_row [gene, studies_populations[study][1], studies_populations[study][2], chrom.split("chr")[1], study, study_qtl, start_pos, stop_pos, score, 10**(-score.to_f), strand, snp, act, notes], :style=>alignment
			end
		end
	end
end

# write an xlsx file
selected_eqtl_result_sets_table.serialize(selected_eqtl_result_sets_out)

