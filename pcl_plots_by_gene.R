# USAGE:
# R --vanilla --args --cox_genes data/COX_pathway_genes.csv < pcl_plots_by_gene.R
# R --vanilla --args --cox_genes data/COX_pathway_genes.csv < pcl_plots_by_gene.R
# R --vanilla --args --cox_genes data/COX_pathway_genes.csv < pcl_plots_by_gene.R
# R --vanilla --args --cox_genes data/COX_pathway_genes.csv < pcl_plots_by_gene.R
dir = "results/found_genes_in_PCLs/"
csv_input_files = list.files(dir, pattern = ".csv")
list_length = length(csv_input_files)

# fix full paths
fullnames = c()
for(i in 1:list_length)
{
	fullnames[i] <- paste(dir, csv_input_files[i], sep="")
}
 
# read csv files for all experiments
experiments <- lapply(fullnames,function(filename){read.table(filename, header=T, sep=",", fill=T)})

# get option
if(require("getopt", quietly=TRUE)) {
	opt <- getopt(matrix(c(
		'cox_genes', 'i', 1, "character", "input cox genes csv file"
	), ncol=5, byrow=TRUE))
	if(!is.null(opt$cox_genes)) {
		cox_genes <- opt$cox_genes
	} else
		q()
}

# read COX genes file
cox_genes_table <- read.table(cox_genes, header=T, sep=",")
cox_genes_ids = cox_genes_table[,4]

# add _at to entrez ids to search them in the csv (PCL) files, where the id is: {entrezid}_at
cox_genes_ids_with_suffix = paste(cox_genes_ids, "_at", sep="")
cox_genes_ids_with_suffix

# subset from the cox_entrez_ids found in the experiments
# ---- NOT FUNCTIONAL YET !!! -----
mean_expression_list <- lapply(cox_genes_ids_with_suffix, function(gene_id) {
	lapply(experiments,function(experiment_table, gene_id) {
		rowMeans(subset(experiment_table, experiment_table$X == gene_id)[,2:length(colnames(experiment_table))])
	}, gene_id)
})

mean_expression_list








