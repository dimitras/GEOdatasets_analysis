#!/usr/bin/ruby
# USAGE: for i in results/*.csv;do (echo $i;./GM_to_NA.rb $i);done
# create GM (GEO samples ids) to NA (coriell ids) lists for all experiments

require 'rubygems'
require 'fastercsv'

infile = ARGV[0]
filename = infile.split("/")[1].split(".")[0]
gm_to_na_ofile = "results/Hapmap/GM2NA_list_#{filename}.csv"

# isolate the ids (ex. 06994) from the GM ids (ex. GM06994_rep1) of all experiments (GSE files)
ids = Hash.new { |h,k| h[k] = [] }
FasterCSV.foreach(infile) do |row|
	row[6..row.length-1].each do |sample|
		if !sample.empty?
			if row.any? { |s| s.include?("Technical replicate") } 
				if !sample.include? "Technical replicate"
					id = sample.split("GM")[1].split(",")[0]
				else 
					next
				end
			else
				id = sample.split("GM")[1].split("_rep")[0]
			end
			ids[id] = nil
		end
	end
	break
end

# export a csv file with a list of all the ids of each experiment
gm_to_na_output = File.open(gm_to_na_ofile, "w")
ids.each_key do |id|
	gm_to_na_output.puts id
end
gm_to_na_output.close

# find the ids of the gm_to_na_output in each sample individual file (CEU, JPT, YRI, CHB) from hapmap (last column contains coriell id, ex. NA06994)
 




