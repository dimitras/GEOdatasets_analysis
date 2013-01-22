# Convert all hapmap genotype files (with merged duplicates) for each sample set (CEU, JPT, YRI, CHB) to ped & map files (plink format) with GluGenetics library and filter them with samples' list (list with those coriell ids that correspond to the GEO ids).

# # CEU group
# for i in results/Hapmap/hapmap_genotypes_2010-08_phaseII+III_forward_with_merged_duplicates/*CEU*.txt
# do
# 	glu -v transform -f hapmap -F ped $i -o results/Hapmap/PLINK_files/CEU/`basename $i`.ped --includesamples='results/Hapmap/hapmap_samples_individuals_filtered_by_GEOsamples_and_founders/pedinfo2sample_CEU.txt'
# done

# # CHB group
# for i in results/Hapmap/hapmap_genotypes_2010-08_phaseII+III_forward_with_merged_duplicates/*CHB*.txt
# do
# 	glu -v transform -f hapmap -F ped $i -o results/Hapmap/PLINK_files/CHB/`basename $i`.ped --includesamples='results/Hapmap/hapmap_samples_individuals_filtered_by_GEOsamples_and_founders/pedinfo2sample_CHB.txt'
# done

# # JPT group
# for i in results/Hapmap/hapmap_genotypes_2010-08_phaseII+III_forward_with_merged_duplicates/*JPT*.txt
# do
# 	glu -v transform -f hapmap -F ped $i -o results/Hapmap/PLINK_files/JPT/`basename $i`.ped --includesamples='results/Hapmap/hapmap_samples_individuals_filtered_by_GEOsamples_and_founders/pedinfo2sample_JPT.txt'
# done

# YRI group
for i in results/Hapmap/hapmap_genotypes_2010-08_phaseII+III_forward_with_merged_duplicates/*YRI*.txt
do
	glu -v transform -f hapmap -F ped $i -o results/Hapmap/PLINK_files/YRI/`basename $i`.ped --includesamples='results/Hapmap/hapmap_samples_individuals_filtered_by_GEOsamples_and_founders/pedinfo2sample_YRI.txt'
done