# USAGE: ruby gene_locis.rb data/eqtl_browser/missed_genes_locis.txt data/eqtl_browser/missed_genes_locis_table.csv

# parse the efetch results from ncbi for the missing genes, and create a table with genename, geneid, start and stop genomic locations

# input file
missed_genes_locis_file = ARGV[0]
# output file
genes_locis_table_file = ARGV[1]
# initialize argument
genes_locis_table = File.open(genes_locis_table_file, 'w')

# parse efetch results from ncbi for the missing genes
genes_locis = Hash.new { |h,k| h[k] = [] }
genename = nil
geneid = nil
chrom = nil
start_position = nil
stop_position = nil
File.open(missed_genes_locis_file).each_line do |line|
	if line =~ /^\d+\.\s(\w+)/
		genename = $1
	elsif line =~ /^Chromosome: (\d+)/
		chrom = $1
	elsif line =~ /\((\d+)\.\.(\d+)\)/
		start_position = $1
		stop_position = $2
	elsif line =~ /^ID: (\d+)/
		geneid = $1
	elsif line == "\n"
		genes_locis[geneid] = [geneid, genename, chrom, start_position, stop_position]
		genes_locis_table.puts genes_locis[geneid].join(",")
	end
end

