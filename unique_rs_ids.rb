#!/usr/bin/ruby
# USAGE: ruby unique_rs_ids.rb
# Filter all hapmap genotype files to get unique rs ids by merging alleles from duplicate rs ids. 
# Between the duplicated rs entries, compare the alleles like this:
# known vs unknown => known
# known == known => known
# known != known => unknown
# ignore the location, origin and other, keep from the one with most retrieved alleles
# Output is a hapmap genotype file tab delimited with merged duplicates.

require 'pathname'

# compare the alleles to merge the duplicated rs ids
def resolve_duplicates(rows_as_strings)
	rows_as_arrays = rows_as_strings.map{|row| row.split(' ')}
	merged_row = rows_as_arrays.first[0..10] # first 11 elements are selected from the first row
	(11..rows_as_arrays.first.length-1).each do |col_idx|
		alleles = []
		rows_as_arrays.each do |row|
			alleles << row[col_idx]
		end
		merged_allele = resolve_alleles(alleles)
		merged_row << merged_allele
	end
	return merged_row.join(" ")
end

# compare and choose the allele
def resolve_alleles(alleles)
	merged_allele = alleles.pop
	alleles.each do |allele|
		if allele == "NN" || allele == merged_allele
			# no need to do anything
		else
			if merged_allele == "NN"
				merged_allele = allele
			else
				return "NN"
			end
		end
	end
	return merged_allele
end

# # retouch the row to keep the first column = rs id and the alleles (samples columns) only, also replace the NN alleles with space
# def to_ldat_format(row)
# 	row_as_array = row.split(' ')
# 	rs_id = row_as_array[0].to_s
# 	alleles_string = row_as_array[11..row.length-1].join("\t")
# 	alleles_string.gsub!("NN", "  ")
# 	return rs_id + "\t" + alleles_string
# end

# io files
# data_path = "data/raw/Hapmap/test_data/"
data_path = "data/raw/Hapmap/hapmap_genotypes_2010-08_phaseII+III_forward/"
results_path = "results/Hapmap/hapmap_genotypes_2010-08_phaseII+III_forward/"

# find interesting files
input_file_list = []
Dir[data_path + "*.txt"].each do |input_file|

	input_pathname = Pathname.new(input_file)
	group = input_pathname.basename.to_s.split("_")[2]

	if group == "CEU" || group == "JPT" || group == "YRI" || group == "CHB"
		input_file_list << input_pathname
	end
end

# find duplicate rs ids (by rows) and merge the alleles of the duplicate entries (by col)
input_file_list.each do |input_pathname|
	input_handle = input_pathname.open
	
	# scan the rs ids and find the duplicates
	rs_ids = {}
	duplicate_rs_ids = {}
	input_handle.each_line do |row|
		rs_id = row.split(" ")[0]
		if rs_ids.include?(rs_id)
			duplicate_rs_ids[rs_id] = []
		else
			rs_ids[rs_id] = nil
		end
	end
	input_handle.rewind
	
	# get the entries for the duplicate rs ids
	input_handle.each_line do |row|
		rs_id = row.split(" ")[0]
		if duplicate_rs_ids.include?(rs_id)
			duplicate_rs_ids[rs_id] << row
		end
	end
	input_handle.rewind

	# merge the rows for the duplicates and store the result in a hash
	merged_row = {}
	duplicate_rs_ids.each do |rs_id, rows|
		merged_row[rs_id] = resolve_duplicates(rows)
	end
	
	# print all lines together with the merged lines for the duplicates (print only once)
	output_handle = File.open(results_path + '/' + input_pathname.basename, "w")
	input_handle.each_line do |row|
		rs_id = row.split(" ")[0]
		if duplicate_rs_ids.include?(rs_id)
			if !merged_row[rs_id].nil?
				output_handle.puts merged_row[rs_id]
# 				output_handle.puts to_ldat_format(merged_row[rs_id])
				merged_row[rs_id] = nil
			end
		else
			output_handle.puts row
# 			output_handle.puts to_ldat_format(row)
		end
	end
end






