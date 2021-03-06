#!/usr/bin/ruby
# USAGE: ruby selected_eqtl_results_for_missed_genes.rb data/eqtl_browser/sample_groups_for_studies.csv  data/eqtl_browser/missed_genes_locis_table.csv data/eqtl_browser/All.individual.tracks.gff.v3 7.0 results/eqtl_results_sets/selected_eqtl_result_sets_by_locis_for_extended_list.xlsx
# No cutoff:
# ruby selected_eqtl_results_for_missed_genes.rb data/eqtl_browser/sample_groups_for_studies.csv  data/eqtl_browser/missed_genes_locis_table.csv data/eqtl_browser/All.individual.tracks.gff.v3 0.0 results/eqtl_results_sets/selected_eqtl_result_sets_by_locis_for_extended_list_nocutoff.xlsx

# Parse the results sets from eqtl browser for MISSED genes, get the results for our genes of interest by checking genomic location (chrom and positions), keeping only the studies included in the sample groups list, and the ones with score cutoff above 7. The sample groups list was filtered by keeping only the Tcells, LCLs and monocytes tissues. Add population and tissue in the output table. The genes locis were found with ncbi efetch and were formatted with gene_locis.rb.

require 'rubygems'
require 'fastercsv'
require 'axlsx'

# input files
sample_groups_file = ARGV[0]
missed_genes_file = ARGV[1]
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


# parse missed genes file into a hash by chrom as a key
missed_genes_per_chrom = Hash.new { |h,k| h[k] = [] }
FasterCSV.foreach(missed_genes_file) do |line|
	missed_genes_per_chrom["chr#{line[2]}"] << line
end
# puts "MISSED GENES:: \n #{missed_genes_per_chrom.inspect}"


# parse eqtl full results sets file and get the selected genes' entries into a hash
selected_eqtl_result_sets_hash = Hash.new { |h,k| h[k] = [] }
File.open(eqtl_full_result_sets_file).each_line do |line|
	chrom = line.split("\t")[0]
	if missed_genes_per_chrom.include?(chrom)
		missed_genes_per_chrom[chrom].each do |gene|
			start_pos = gene[3].to_i
			stop_pos = gene[4].to_i
			snp_pos = line.split("\t")[3].to_i
			if (start_pos-10000 <= snp_pos) && (snp_pos <= stop_pos+10000) # within 10Kbp in the coding region
				study = line.split("\t")[1].to_s
				if study =~ /^(\D+)((\d+_\w+)|(_\w+))$/
					study = $1
				else
					study
				end
				if studies_populations.has_key?(study)
					score = line.split("\t")[5].to_f
					if line.include?("Alias") 
						genename = line.split("Alias ")[1].split(" ;")[0].to_s
					elsif line.include?("eQTL for")
						genename = line.split("eQTL for ")[1].split("\";")[0].to_s
					end

					if score >= score_cutoff
						selected_eqtl_result_sets_hash[genename] << line
					end
				end
			end
		end
	end
end
# puts "RESULTS:: \n #{selected_eqtl_result_sets_hash.keys.join(", ")}"


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

