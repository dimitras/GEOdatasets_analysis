# USAGE: 
# R --vanilla --args --coxf data/COX_pathway_genes.csv --pclf results/PCLs/GSE1485.csv --identifier GSE1485 --ofile results/found_genes_in_PCLs/GSE1485_found_in_PCL.csv < find_coxgenes_in_pcl.R
# R --vanilla --args --coxf data/COX_pathway_genes.csv --pclf results/PCLs/GSE2552.csv --identifier GSE2552 --ofile results/found_genes_in_PCLs/GSE2552_found_in_PCL.csv < find_coxgenes_in_pcl.R
# R --vanilla --args --coxf data/COX_pathway_genes.csv --pclf results/PCLs/GSE5859.csv --identifier GSE5859 --ofile results/found_genes_in_PCLs/GSE5859_found_in_PCL.csv < find_coxgenes_in_pcl.R
# R --vanilla --args --coxf data/COX_pathway_genes.csv --pclf results/PCLs/GSE10824.csv --identifier GSE10824 --ofile results/found_genes_in_PCLs/GSE10824_found_in_PCL.csv < find_coxgenes_in_pcl.R


library("AnnotationDbi")
library("GO.db")
library("hgfocus.db") # chip

# Get options
if(require("getopt", quietly=TRUE)) {
	opt <- getopt(matrix(c(
		'coxf', 'c', 1, "character", "input cox table file",
		'pclf', 'p', 1, "character", "input csv (pcl) file",
		'identifier', 'i', 1, "character", "identifier for file",
		'ofile', 'o', 1, "character", "output table file"
	), ncol=5, byrow=TRUE))
	if(!is.null(opt$coxf) | !is.null(opt$identifier)) {
		coxf <- opt$coxf
		pclf <- opt$pclf
		identifier <- opt$identifier
		ofile <- opt$ofile
	} else
		q()
}

# COX genes file
cox_genes <- read.table(coxf, header=T, sep=",")
cox_genes_ids = cox_genes[,4]

# add _at to entrez ids to search them in the csv (PCL) files, where the id is: {entrezid}_at
cox_genes_ids_with_suffix = paste(cox_genes_ids, "_at", sep="")

# read csv file with all probes
probe_entries <- read.table(pclf, header=T, sep=",", fill=T)

# subset from the cox_entrez_ids found in the experiments
cox_genes_pos <- match(cox_genes_ids_with_suffix, probe_entries[,1])
cox_genes_found = probe_entries[cox_genes_pos,]

# export to file
write.table(cox_genes_found, file = ofile, sep = ",", row.names = FALSE)


# -------- if the ids in the csv (PCL) files are the probe ids ---------
# 
# # map entrez ids from the db
# entrez_ids_map <- hgfocusENTREZID
# # get the probe identifiers that are mapped to an ENTREZ Gene ID
# mapped_probes <- mappedkeys(entrez_ids_map)
# # convert to a list
# entrez_ids <- as.list(entrez_ids_map[mapped_probes])
# # find cox genes' positions in the db list
# cox_genes_ids_pos = match(cox_genes_ids_with_suffix,entrez_ids)
# # get the probe ids for these positions
# cox_probe_ids = names(entrez_ids)[cox_genes_ids_pos]
# 
# # read csv file with all probes
# probe_entries <- read.table("results/PCLs/GSE1485.csv", header=T, sep=",", fill=T)
# 
# # subset from the cox_probe_ids found in the probe_entries
# cox_genes_pos <- match(cox_probe_ids, probe_entries)
# cox_genes_found = table[cox_genes_pos]
# 
# # export to file
# write.table(cox_genes_found, file="results/GSE1485_found_in_PCL.csv", sep = ",", row.names = FALSE)