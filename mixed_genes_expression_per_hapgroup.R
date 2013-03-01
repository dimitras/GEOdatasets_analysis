# R --vanilla --args --ifile results/eqtl_results_sets/CV_plots/mixed_genes_found_in_CEU.csv --hapgroup CEU --avgplot_out results/eqtl_results_sets/CV_plots/mixed_genes_expressions_barplots_per_hapgroup/CEU_avgplot.pdf --varplot_out results/eqtl_results_sets/CV_plots/mixed_genes_expressions_barplots_per_hapgroup/CEU_varplot.pdf --sdplot_out results/eqtl_results_sets/CV_plots/mixed_genes_expressions_barplots_per_hapgroup/CEU_sdplot.pdf < mixed_genes_expression_per_hapgroup.R


# Barplot the average, variance, and standard deviation in gene expression level for COX pathway genes & housekeeping, per hapgroup

library(plotrix)
library(RColorBrewer)

# Get options
if(require("getopt", quietly=TRUE)) {
	opt <- getopt(matrix(c(
		'ifile', 'i', 1, "character", "input table file",
		'hapgroup', 'g', 1, "character", "identifier for file",
		'avgplot_out', 'a', 1, "character", "output AVG plot file",
		'varplot_out', 'v', 1, "character", "output VARIANCE plot file",
		'sdplot_out', 's', 1, "character", "output STANDARD DEVIATION plot file"
	), ncol=5, byrow=TRUE))
	if(!is.null(opt$ifile) | !is.null(opt$hapgroup)) {
		ifile <- opt$ifile
		hapgroup <- opt$hapgroup
		avgplot_out <- opt$avgplot_out
		varplot_out <- opt$varplot_out
		sdplot_out <- opt$sdplot_out
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
    xvals <- barplot(value, names.arg=names, las=2, col=mypalette[8], main=paste("COX pathway genes in",hapgroup), ylab=ylabel) # Plot bars
    arrows(xvals, value, xvals, bar.H, length = 0.05, angle=90) # Draw error bars
    arrows(xvals, value, xvals, bar.L, length = 0.05, angle=90)
}

# # make the barplot for average expression and standard error
# pdf(avgplot_out)
# bar.plot(rowMeans(found_gene_expressions[,8:ncol]), apply(found_gene_expressions[,8:ncol],1,std.error), found_gene_expressions$V1, "Average expression with standard error")
# dev.off()

# make the barplot for variance expression and standard error
pdf(varplot_out)
barplot(apply(found_gene_expressions[,8:ncol],1,var),names.arg=found_gene_expressions$V1,las=2, col=c(mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[3],mypalette[3],mypalette[8],mypalette[8],mypalette[8],mypalette[10],mypalette[10],mypalette[10],mypalette[10],mypalette[10]), main=paste("COX pathway & housekeeping genes in ",hapgroup), ylab="Variance expression")
legend('topright', c("COX pathway genes","COX1&2","Housekeeping genes"), pch=c(15,15), col=c(mypalette[8], mypalette[3],mypalette[10]))
dev.off()

# make the barplot for standard deviation expression and standard deviation error
pdf(sdplot_out)
barplot(apply(found_gene_expressions[,8:ncol],1,sd),names.arg=found_gene_expressions$V1,las=2, col=c(mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[8],mypalette[3],mypalette[3],mypalette[8],mypalette[8],mypalette[8],mypalette[10],mypalette[10],mypalette[10],mypalette[10],mypalette[10]), main=paste("COX pathway & housekeeping genes in",hapgroup), ylab="Standard deviation expression")
legend('topright', c("COX pathway genes","COX1&2","Housekeeping genes"), pch=c(15,15), col=c(mypalette[8], mypalette[3],mypalette[10]))
dev.off()
