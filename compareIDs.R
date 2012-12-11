library(Biobase)
library(GEOquery)

# open files
gse1 <- getGEO('GSE1485', GSEMatrix=FALSE, destdir="data/raw/GEO_raw/downloads")
gse2 <- getGEO('GSE2552', GSEMatrix=FALSE, destdir="data/raw/GEO_raw/downloads")
gse3 <- getGEO('GSE5859', GSEMatrix=FALSE, destdir="data/raw/GEO_raw/downloads")
gse4 <- getGEO('GSE10824', GSEMatrix=FALSE, destdir="data/raw/GEO_raw/downloads")

# names of all the GSM objects contained in the GSE, sorted alphabetically
gse1_names = sort(names(GSMList(gse1)))
gse2_names = sort(names(GSMList(gse2)))
gse3_names = sort(names(GSMList(gse3)))
gse4_names = sort(names(GSMList(gse4)))

# compare the GSM ids
match( gse1_names, gse2_names )
length(match(gse1_names, gse2_names)[!is.na(match(gse1_names, gse2_names))]) #84

match( gse1_names, gse3_names )
length(match(gse1_names, gse3_names)[!is.na(match(gse1_names, gse3_names))]) #84

match( gse2_names, gse3_names )
length(match(gse2_names, gse3_names)[!is.na(match(gse2_names, gse3_names))]) #99

match( gse1_names, gse4_names )
length(match(gse1_names, gse4_names)[!is.na(match(gse1_names, gse4_names))]) #0

