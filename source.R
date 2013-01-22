# R --vanilla --args --identifier GSE1485 --ofile results/GSE1485.csv --genesfile results/gene_lists/GSE1485_genes.csv < source.R
# R --vanilla --args --identifier GSE2552 --ofile results/GSE2552.csv --genesfile results/gene_lists/GSE2552_genes.csv < source.R
# R --vanilla --args --identifier GSE5859 --ofile results/GSE5859.csv --genesfile results/gene_lists/GSE5859_genes.csv < source.R
# R --vanilla --args --identifier GSE10824 --ofile results/GSE10824.csv --genesfile results/gene_lists/GSE10824_genes.csv < source.R

# Retrieve GEO datasets, create file lists with GSM samples and gene ids per probe.

library(Biobase)
library(GEOquery)

# Get options
if(require("getopt", quietly=TRUE)) {
	opt <- getopt(matrix(c(
		'ifile', 'i', 1, "character", "input table file",
		'identifier', 'a', 1, "character", "identifier for file",
		'ofile', 'o', 1, "character", "output table file",
		'genesfile', 'g', 1, "character", "output genes file"
	), ncol=5, byrow=TRUE))
	if(!is.null(opt$ifile) | !is.null(opt$identifier)) {
		ifile <- opt$ifile
		identifier <- opt$identifier
		ofile <- opt$ofile
		genesfile <- opt$genesfile
	} else
		q()
}

# open file
if(!is.null(ifile)) {
	gse <- getGEO(filename=ifile)
} else if (!is.null(identifier)) {
	gse <- getGEO(identifier,GSEMatrix=FALSE, destdir="data/raw/GEO_raw/downloads")
} else
	q()


# check platforms
gsmplatforms <- lapply(GSMList(gse),function(x) {Meta(x)$platform})


# get the probeset ordering
probesets <- Table(GPLList(gse)[[1]])$ID


# make the data matrix from the VALUE columns from each GSM
data.matrix <- do.call('cbind',lapply(GSMList(gse),function(x) {
	tab <- Table(x)
	mymatch <- match(probesets,tab$ID_REF)
	return(tab$VALUE[mymatch])
}))
data.matrix <- apply(data.matrix,2,function(x) {as.numeric(as.character(x))})
data.matrix <- log2(data.matrix)

 
# make the data matrix from the VALUE columns from each GSM
sample.matrix <- do.call('cbind',lapply(GSMList(gse),function(x){
	met <- Meta(x)
	return(met$title)
}))

 
# join the gse and all gsm tables
annotation_table = Table(GPLList(gse)[[1]])
new_table = cbind(as.character(probesets), as.character(annotation_table$'Gene Symbol'), as.character(annotation_table$'ENTREZ_GENE_ID'), as.character(annotation_table$'RefSeq Transcript ID'), as.character(annotation_table$'Representative Public ID'), as.character(annotation_table$'GB_ACC'), data.matrix)
# set column names
new_table.colnames = colnames(new_table)
new_table.colnames[1] = "ID_REF"
new_table.colnames[2] = "Gene Symbol"
new_table.colnames[3] = "ENTREZ_GENE_ID"
new_table.colnames[4] = "RefSeq Transcript ID"
new_table.colnames[5] = "Representative Public ID"
new_table.colnames[6] = "GB_ACC"
colnames(new_table) = new_table.colnames


# create file
write.table(cbind('','','','','','', sample.matrix), file=ofile, sep = ",", row.names = FALSE, col.names = FALSE)
write.table(new_table, file=ofile, sep = ",", row.names = FALSE, append = TRUE)


# create genes list (NOT USED)
new_table_genes = c(as.character(annotation_table$'Gene Symbol'))
g = table(new_table_genes)
# g[names(g)==as.character('STAT1')] # count STAT1
write.table(g, file=genesfile, sep = ",", row.names = FALSE, col.names = FALSE)


