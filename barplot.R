# R --vanilla --args --ifile results/found_genes/GSE10824_found_genes.csv --gse_id GSE10824 --avgplot_out results/found_genes/GSE10824_avgplot.pdf --varplot_out results/found_genes/GSE10824_varplot.pdf --sdplot_out results/found_genes/GSE10824_sdplot.pdf --ecdfplot_out results/found_genes/GSE10824_ecdfplot.pdf < barplot.R
# R --vanilla --args --ifile results/found_genes/GSE1485_found_genes.csv --gse_id GSE1485 --avgplot_out results/found_genes/GSE1485_avgplot.pdf --varplot_out results/found_genes/GSE1485_varplot.pdf --sdplot_out results/found_genes/GSE1485_sdplot.pdf < barplot.R
# R --vanilla --args --ifile results/found_genes/GSE2552_found_genes.csv --gse_id GSE2552 --avgplot_out results/found_genes/GSE2552_avgplot.pdf --varplot_out results/found_genes/GSE2552_varplot.pdf --sdplot_out results/found_genes/GSE2552_sdplot.pdf < barplot.R
# R --vanilla --args --ifile results/found_genes/GSE5859_found_genes.csv --gse_id GSE5859 --avgplot_out results/found_genes/GSE5859_avgplot.pdf --varplot_out results/found_genes/GSE5859_varplot.pdf --sdplot_out results/found_genes/GSE5859_sdplot.pdf < barplot.R

# Barplot the average, variance, and standard deviation in gene expression level for COX pathway genes

library(plotrix)
library(RColorBrewer)

# Get options
if(require("getopt", quietly=TRUE)) {
	opt <- getopt(matrix(c(
		'ifile', 'i', 1, "character", "input table file",
		'gse_id', 'g', 1, "character", "identifier for file",
		'avgplot_out', 'a', 1, "character", "output AVG plot file",
		'varplot_out', 'v', 1, "character", "output VARIANCE plot file",
		'sdplot_out', 's', 1, "character", "output STANDARD DEVIATION plot file",
		'ecdfplot_out', 'e', 1, "character", "output ECDF plot file"
	), ncol=5, byrow=TRUE))
	if(!is.null(opt$ifile) | !is.null(opt$gse_id)) {
		ifile <- opt$ifile
		gse_id <- opt$gse_id
		avgplot_out <- opt$avgplot_out
		varplot_out <- opt$varplot_out
		sdplot_out <- opt$sdplot_out
		ecdfplot_out <- opt$ecdfplot_out
	} else
		q()
}

mypalette<-brewer.pal(11, "RdYlBu")

# read file
found_gene_expressions <- read.table(ifile, header=F, sep=",")
# count the number of columns in the file
ncol <- max(count.fields(ifile, sep = ","))

# function to calculate the standard error
bar.plot <- function(value, stderr, names, ylabel) { # value can be average, or variance, or standard deviation and so on
    bar.H <- value+stderr # Calculate upper value
    bar.L <- value-stderr # Calculate lower value
    xvals <- barplot(value, names.arg=names, las=2, col=mypalette[8], main=paste("COX pathway genes in",gse_id), ylab=ylabel) # Plot bars
    arrows(xvals, value, xvals, bar.H, length = 0.05, angle=90) # Draw error bars
    arrows(xvals, value, xvals, bar.L, length = 0.05, angle=90)
}

# make the barplot for average expression and standard error
pdf(avgplot_out)
bar.plot(rowMeans(found_gene_expressions[,8:ncol]), apply(found_gene_expressions[,8:ncol],1,std.error), found_gene_expressions$V1, "Average expression with standard error")
dev.off()

# make the barplot for variance expression and standard error
pdf(varplot_out)
barplot(apply(found_gene_expressions[,8:ncol],1,var),names.arg=found_gene_expressions$V1,las=2, col=mypalette[8], main=paste("COX pathway genes in",gse_id), ylab="Variance expression")
dev.off()

# make the barplot for standard deviation expression and standard deviation error
pdf(sdplot_out)
barplot(apply(found_gene_expressions[,8:ncol],1,sd),names.arg=found_gene_expressions$V1,las=2, col=mypalette[8], main=paste("COX pathway genes in",gse_id), ylab="Standard deviation expression")
dev.off()


# # ECDF plot
# pdf(ecdfplot_out)
# plot( apply(found_gene_expressions[,8:ncol],1,ecdf),names.arg=found_gene_expressions$V1, verticals=TRUE, do.points=FALSE, col.points = colors, col.hor="darkgreen", col.vert="darkgreen",  lwd=2, pch=20, cex=1.5, xaxs="r", xlim=c(0,100), ylab="Expression", main=paste("Empirical Cumulative Distribution for COX pathway genes in",gse_id) )
# dev.off()

