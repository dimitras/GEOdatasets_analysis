# merge the same population's genes that were found in the different geogroups
# Before running this script, merge all groups for CEU by the following command: 
# paste -d ',' results/eqtl_results_sets/CV_plots/mixed_genes_found_in_geo_groups/mixed_genes_found_in_GSE1485_of_CEU.csv results/eqtl_results_sets/CV_plots/mixed_genes_found_in_geo_groups/mixed_genes_found_in_GSE2552_of_CEU.csv results/eqtl_results_sets/CV_plots/mixed_genes_found_in_geo_groups/mixed_genes_found_in_GSE5859_of_CEU.csv results/eqtl_results_sets/CV_plots/mixed_genes_found_in_geo_groups/mixed_genes_found_in_GSE10824_of_CEU.csv > results/eqtl_results_sets/CV_plots/mixed_genes_found_in_geo_groups/merged_genes_for_CEU.csv

# keep the unique gm ids (columns) in the merged file
# USAGE: ruby merge_genes_per_population.rb results/eqtl_results_sets/CV_plots/mixed_genes_found_in_geo_groups/merged_genes_for_CEU.csv

require 'rubygems'
require 'fastercsv'

merged_per_hapgroup_file = ARGV[0]
group = merged_per_hapgroup_file.split("/")[4].split("_")[3].split(".")[0]
merged_found_genes_in_group_output_file = "results/eqtl_results_sets/CV_plots/mixed_genes_found_in_#{group}.csv"

merged_genes_of_group_output = File.open(merged_found_genes_in_group_output_file, "w")
gm_ids = {}

FasterCSV.foreach(merged_per_hapgroup_file) do |row|
	if gm_ids.empty?
		row.each_with_index do |cell,index|
			if !cell.nil? && !gm_ids.has_key?(cell.to_s)
				gm_ids[cell.to_s] = index
			end
		end
	else
		selected_columns = []
		selected_columns << row[0..6]
		gm_ids.each do |id,index|
			selected_columns << row[index]
		end
		merged_genes_of_group_output.puts selected_columns.join(',')
	end
end


