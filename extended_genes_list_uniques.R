# read the extended genes list file
entries <- read.table("data/extended_cox_pathway_genes.csv", header=T, sep=",", fill=T)

# find uniques
unique_entries <- subset(entries, !duplicated(entries[,1]))

# export to file
write.table(unique_entries, file="data/extended_cox_pathway_genes_uniques.csv", sep = ",", row.names = FALSE)
