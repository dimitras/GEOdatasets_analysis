# R --vanilla --args --ifile results/found_genes/GSE10824_found_genes.csv --identifier GSE10824 --ofile results/found_genes/GSE10824.pdf < barplot.R
# R --vanilla --args --ifile results/found_genes/GSE1485_found_genes.csv --identifier GSE1485 --ofile results/found_genes/GSE1485.pdf < barplot.R
# R --vanilla --args --ifile results/found_genes/GSE2552_found_genes.csv --identifier GSE2552 --ofile results/found_genes/GSE2552.pdf < barplot.R
# R --vanilla --args --ifile results/found_genes/GSE5859_found_genes.csv --identifier GSE5859 --ofile results/found_genes/GSE5859.pdf < barplot.R

library(plotrix)
library(RColorBrewer)

# Get options
if(require("getopt", quietly=TRUE)) {
	opt <- getopt(matrix(c(
		'ifile', 'i', 1, "character", "input table file",
		'identifier', 'a', 1, "character", "identifier for file",
		'ofile', 'o', 1, "character", "output table file"
	), ncol=5, byrow=TRUE))
	if(!is.null(opt$ifile) | !is.null(opt$identifier)) {
		ifile <- opt$ifile
		identifier <- opt$identifier
		ofile <- opt$ofile
	} else
		q()
}

mypalette<-brewer.pal(11, "RdYlBu")

# read file
found_gene_expressions <- read.table(ifile, header=F, sep=",")
# count the number of columns in the file
ncol <- max(count.fields(ifile, sep = ","))

# function to calculate the standard error
AVG.plot <- function(mean, stderr, names) {
    AVG.H <- mean+stderr # Calculate upper AVG
    AVG.L <- mean-stderr # Calculate lower AVG
    xvals <- barplot(mean, names.arg=names, las=2, col=mypalette[8], main=paste("COX pathway genes in",identifier), ylab="Average expression") # Plot bars
    arrows(xvals, mean, xvals, AVG.H, length = 0.05, angle=90) # Draw error bars
    arrows(xvals, mean, xvals, AVG.L, length = 0.05, angle=90)
}

# make the barplot for average expression and standard error
pdf(ofile)
AVG.plot(rowMeans(found_gene_expressions[,8:ncol]), apply(found_gene_expressions[,8:ncol],1,std.error), found_gene_expressions$V1)
dev.off()