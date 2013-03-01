# USAGE:
# source("allele_frequencies_plot.R")
# plot_allele_frequencies("results/eqtl_results_sets/region_graphs/only_SNPs_of_PTGS2.csv", "data/raw/Hapmap/allele_frequencies/allele_freqs_chr1_CEU_r28_nr.b36_fwd.txt", "results/eqtl_results_sets/allele_frequencies_plots/allele_frequencies_PTGS2", "PTGS2")

# plot_allele_frequencies("results/eqtl_results_sets/region_graphs/only_SNPs_of_PTGS1.csv", "data/raw/Hapmap/allele_frequencies/allele_freqs_chr9_YRI_r28_nr.b36_fwd.txt", "results/eqtl_results_sets/allele_frequencies_plots/allele_frequencies_PTGS1", "PTGS1")

# plot allele frequencies for selected SNPs, per gene
plot_allele_frequencies <- function(selected_snps_file, entries_file, out_figure_file, gene) {
	library(RColorBrewer)
	mypalette<-brewer.pal(5, "RdBu")

	selected_snps <- read.table(selected_snps_file, header=TRUE, sep=",")
	entries <- read.table(entries_file, header=TRUE, sep=" ") # the allele frequencies file downloaded from hapmap

	selected_entries <- subset(entries, entries$rs %in% selected_snps$SNP) # the SNPs of the gene I want to plot
	# minor_freqs <- apply(selected_entries, 1, function(row){min(c(row[12],row[15]))}) # choose the minor freq
	freq_matrix = rbind(selected_entries$refallele_freq, selected_entries$otherallele_freq)

	svg(paste(out_figure_file,".svg",sep=""))
	par(mar=c(7.1, 4.1, 4.1, 2.1))
	barplot(freq_matrix, names.arg=selected_entries$rs,
		beside=TRUE, ylim=c(0,1), las=2,
		col=c(mypalette[1], mypalette[5]),
# 		legend=c("Reference_frequency","Other_frequency"),
		ylab="Allele frequency",
		main=paste("Allele frequencies for SNPs of", gene)
		)
	legend(20.0,0.6, c("Reference_frequency","Other_frequency"), pch=c(15,15), col=c(mypalette[1], mypalette[5]))
	dev.off()
	
	png(paste(out_figure_file,".png",sep=""))
	par(mar=c(7.1, 4.1, 4.1, 2.1))
	barplot(freq_matrix, names.arg=selected_entries$rs,
		beside=TRUE, ylim=c(0,1), las=2,
		col=c(mypalette[1], mypalette[5]),
# 		legend=c("Reference_frequency","Other_frequency"),
		ylab="Allele frequency",
		main=paste("Allele frequencies for SNPs of", gene)
		)
	legend(20.0,0.6, c("Reference_frequency","Other_frequency"), pch=c(15,15), col=c(mypalette[1], mypalette[5]))
	dev.off()
}

