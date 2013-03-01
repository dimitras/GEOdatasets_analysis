
# ran with wrong axis
library(gap)
data <- read.table("results/eqtl_results_sets/region_graphs/ptgs1.csv", header=T, sep=",")
png("results/eqtl_results_sets/region_graphs/ptgs1.png")
mhtplot(data, control=mht.control(type="l",logscale=FALSE, colors=c("red")), hcontrol=hmht.control(), xlab="SNP loci (in chr9)", ylab="-log10(P)")
axis(1)
axis(2)
title("SNPs found in PTGS1",cex.main=1.8)
dev.off()


################################################################################
# This is the working part
# Use http://people.virginia.edu/~sdt5z/0STABLE/qqman.r function for manhattan plotting
# Make the files as described here: http://gettinggeneticsdone.blogspot.com/2011/04/annotated-manhattan-plots-and-qq-plots.html
# ex. the csv files per gene have columns named SNP, CHR, BP, and P, corresponding to the SNP name (rs number), chromosome number, genomic coordinate, and p-value
# CHR contains number only
# P is the p-value (so I calculate it when I export the tables from gff filtering)
# to plot the genomic region markers, I scan the missed_genes_locis_table.csv and get the start and stop positions for the gene in interest
# highlight the SNPs that are above the cutoff 7.0 (snps_to_highlight is a text file with the rs ids in seperate lines)
################################################################################

# CURRENT: works, with changed scale
#1
source("qqman.R")
data <- read.table("results/eqtl_results_sets/region_graphs/ptgs1.csv", header=TRUE, sep=",")
# points to highlight
snps_to_highlight <- scan("results/eqtl_results_sets/region_graphs/snps_to_highlight_in_ptgs1.txt", character())
svg("results/eqtl_results_sets/region_graphs/ptgs1.svg")
manhattan(data, annotate=snps_to_highlight, pch=20, suggestiveline=FALSE, genomewideline=FALSE, main="SNPs found in PTGS1", colors="black", xlim=c(1241.5,1251.6), panel.first = grid())
axis(3, at=c(data$BP), labels=paste(c(data$BP),"K"))
# draw directionality
arrows(1241.5,0.5,1251.6,0.5, lty=2, col="pink", lwd=1.5)
# for cutoff and genomic region markers
abline(h=7.0, lty=1, col="red")
abline(v=c(1251.32809,1251.57982), lty=2, col="blue")
# rug(c(1251.32809,1251.57982), col=2, lwd=2)
# for legends
legend(1248.0,9.2, c("Significance cutoff","Gene region", "Directionality"), lty=c(1,2,2), lwd=c(2.5,2.5,1.5), col=c("red","blue","pink"))
legend(1248.0,7.7, c("Significant SNPs","SNPs"), pch= c(20,20), col=c("green","black"))
dev.off()
# 2
source("qqman.R")
data <- read.table("results/eqtl_results_sets/region_graphs/ptgs2.csv", header=TRUE, sep=",")
# points to highlight
snps_to_highlight <- scan("results/eqtl_results_sets/region_graphs/snps_to_highlight_in_ptgs2.txt", character())
svg("results/eqtl_results_sets/region_graphs/ptgs2.svg")
manhattan(data, annotate=snps_to_highlight, pch=20, suggestiveline=FALSE, genomewideline=FALSE, main="SNPs found in PTGS2", colors="black", xlim=c(1846.71,1866.51), panel.first = grid())
axis(3, at=c(data$BP), labels=paste(c(data$BP),"K"))
# draw directionality
arrows(1866.51,0.5,1846.71,0.5, lty=2, col="pink", lwd=1.5)
# for cutoff and genomic region markers
abline(h=7.0, lty=1, col="red")
abline(v=c(1866.40944,1866.49559), lty=2, col="blue")
# for legends
legend(1859.4,16.6, c("Significance cutoff","Gene region", "Directionality"), lty=c(1,2,2), lwd=c(2.5,2.5,1.5), col=c("red","blue","pink"))
legend(1859.4,14, c("Significant SNPs","SNPs"), pch= c(20,20), col=c("green","black"))
dev.off()


# only the SNPs
#1
source("qqman.R")
data <- read.table("results/eqtl_results_sets/region_graphs/ptgs1.csv", header=TRUE, sep=",")
# points to highlight
snps_to_highlight <- scan("results/eqtl_results_sets/region_graphs/snps_to_highlight_in_ptgs1.txt", character())
svg("results/eqtl_results_sets/region_graphs/ptgs1_only_snps_region.svg")
manhattan(data, annotate=snps_to_highlight, pch=20, suggestiveline=FALSE, genomewideline=FALSE, main="SNPs found in PTGS1", colors="black", xlim=c(1241.8,1242.0), panel.first = grid())
axis(3, at=c(data$BP), labels=paste(c(data$BP),"K"))
# for cutoff
abline(h=7.0, lty=1, col="red")
# for legends
legend(1241.932,0.87, c("Significance cutoff"), lty=c(1), lwd=c(2.5), col=c("red"))
legend(1241.947,2.0, c("Significant SNPs","SNPs"), pch= c(20,20), col=c("green","black"))
dev.off()
# 2
source("qqman.R")
data <- read.table("results/eqtl_results_sets/region_graphs/ptgs2.csv", header=TRUE, sep=",")
# points to highlight
snps_to_highlight <- scan("results/eqtl_results_sets/region_graphs/snps_to_highlight_in_ptgs2.txt", character())
svg("results/eqtl_results_sets/region_graphs/ptgs2_only_snps_region.svg")
manhattan(data, annotate=snps_to_highlight, pch=20, suggestiveline=FALSE, genomewideline=FALSE, main="SNPs found in PTGS2", colors="black", xlim=c(1846.6,1849.0), panel.first = grid())
axis(3, at=c(data$BP), labels=paste(c(data$BP),"K"))
# for cutoff
abline(h=7.0, lty=1, col="red")
# for legends
legend(1848.19,2.0, c("Significance cutoff"), lty=c(1), lwd=c(2.5), col=c("red"))
legend(1848.37,4.0, c("Significant SNPs","SNPs"), pch= c(20,20), col=c("green","black"))
dev.off()


# CURRENT version: only the SNPs
# 1
data <- read.table("results/eqtl_results_sets/region_graphs/only_SNPs_of_PTGS1.csv", header=TRUE, sep=",")
# svg("results/eqtl_results_sets/region_graphs/ptgs1_only_snps_region.svg")
pdf("results/eqtl_results_sets/region_graphs/ptgs1_only_snps_region.pdf")
par(pin=c(6.0,3.0))
plot(data$POS, data$LOG, axes=F, frame=T, main="SNPs of PTGS1 (CHR9)", xlab="", ylab="-log10(P)", pch=20, col="red", xlim=c(1241.803,1242.02), panel.first = grid())
text(data$POS, data$LOG, data$SNP, cex=0.8, pos=4, col="red")
axis(2, tck=-.01)
axis(1, at=c(data$POS), labels=paste(c(data$POS),"K"), las=2, cex.axis=0.8)
# abline(h=7.0, lty=1, col="red")
dev.off()

# 2
data <- read.table("results/eqtl_results_sets/region_graphs/only_SNPs_of_PTGS2.csv", header=TRUE, sep=",")
# svg("results/eqtl_results_sets/region_graphs/ptgs2_only_snps_region.svg")
pdf("results/eqtl_results_sets/region_graphs/ptgs2_only_snps_region.pdf")
par(pin=c(6.0,3.0))
plot(data$POS, data$LOG, axes=F, frame=T, main="SNPs of PTGS2 (CHR1)", xlab="", ylab="-log10(P)", pch=20, col="red", xlim=c(1846.6,1849.2), panel.first = grid())
text(data$POS, data$LOG, data$SNP, cex=0.8, pos=4, col="red")
axis(2, tck=-.01)
axis(1, at=c(data$POS), labels=paste(c(data$POS),"K"), las=2, cex.axis=0.8)
# abline(h=7.0, lty=1, col="red")
dev.off()



