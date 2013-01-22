#!/usr/bin/ruby
# USAGE: ruby coriell_founders_list.rb results/Hapmap/GM2NA_lists/ data/raw/Hapmap/hapmap_samples_individuals/ results/Hapmap/hapmap_samples_individuals_filtered_by_GEOsamples_and_founders/
# Get the sample-individuals with the coriell ids that correspond to the GEO ids, and also fulfill the criterion of being a founder (0 for a founder)

require 'pathname'

# input files
coriell_ids_path = ARGV[0]
coriell_ids_file_list = []
Dir[coriell_ids_path + "*.csv"].each do |coriell_ids_ifile|
	coriell_ids_file_pathname = Pathname.new(coriell_ids_ifile)
	coriell_ids_file_list << coriell_ids_file_pathname
end

samples_path = ARGV[1]
samples_file_list = []
Dir[samples_path + "*.txt"].each do |sample_ifile|
	sample_pathname = Pathname.new(sample_ifile)
	samples_file_list << sample_pathname
end

# output files
results_path = ARGV[2]

# read all samples lists and make a unified hash list with all the coriell ids of the GEO experiments (NA#)
coriell_ids_full_list = {}
coriell_ids_file_list.each do |coriell_ids_file|
	input_handle = coriell_ids_file.open

	input_handle.each_line do |row|
		coriell_ids_full_list["NA"+row.to_s.delete("\n")] = nil
	end
end

# find NA ids in the samples files and filter by founders = 0
samples_file_list.each do |sample_file|
	sample_handle = sample_file.open
	output_handle = File.open(results_path + sample_file.basename, "w")

	sample_handle.each_line do |row|
		row_as_array = row.split("\t")
		sample_id = row_as_array[6].split(":")[4].to_s
		paternal_id = row_as_array[2].to_i
		maternal_id = row_as_array[3].to_i
		if coriell_ids_full_list.include?(sample_id) && (paternal_id == 0 || maternal_id == 0)
			output_handle.puts sample_id
		end
	end
end


