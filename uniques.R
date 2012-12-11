# read the file
entries <- read.table("data/raw/nsaid_pathway_gene_list.csv", header=T, sep=",", fill=T)

# find uniques
unique_entries <- subset(entries, !duplicated(entries[,2]))

# export to file
write.table(unique_entries, file="results/extra/nsaid_pathway_gene_list_uniques.csv", sep = ",", row.names = FALSE)
