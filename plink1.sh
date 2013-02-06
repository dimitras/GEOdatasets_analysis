#!/bin/bash
#
# impute sex
cd ~/PLINK/data/CEU
~/PLINK/plink-1.07-x86_64/plink --noweb --impute-sex --make-bed --file "genotypes_chrX_CEU_r28_nr.b36_fwd.txt" --out "genotypes_chrX_CEU_r28_nr.b36_fwd.txt" 
#
# check imputed sex
cut -f 1,5 -d ' ' genotypes_chrX_CEU_r28_nr.b36_fwd.txt.fam | sort > tmp1.txt
awk '{print $2" "$1}' ../hapmap_samples_individuals_filtered_by_coriell_ids_and_founders/pedinfo2sample_CEU_2.txt | sort > tmp2.txt
join -j 1 tmp1.txt tmp2.txt > tmp3.txt
cat tmp3.txt | grep -v "1 1" | grep -v "2 2" # should be empty
#
# make other binary files
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 Y
do
  ~/PLINK/plink-1.07-x86_64/plink --noweb --make-bed --file "genotypes_chr"$c"_CEU_r28_nr.b36_fwd.txt" --out "genotypes_chr"$c"_CEU_r28_nr.b36_fwd.txt" 
done
#
# check differences in sex
rm tmp4.txt
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 Y
do
  cut -f 1 -d ' ' "genotypes_chr"$c"_CEU_r28_nr.b36_fwd.txt.fam" > tmp1.txt
  cut -f 1 -d ' ' genotypes_chrX_CEU_r28_nr.b36_fwd.txt.fam > tmp2.txt
  diff tmp1.txt tmp2.txt >> tmp4.txt
done
cat tmp4.txt # should be empty
#
# copy across fam files
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 Y
do
  cp genotypes_chrX_CEU_r28_nr.b36_fwd.txt.fam "genotypes_chr"$c"_CEU_r28_nr.b36_fwd.txt.fam"
done
rm *.nosex
#
# get rid of females from Y chromosome file
~/PLINK/plink-1.07-x86_64/plink --noweb --filter-males --make-bed --bfile "genotypes_chrY_CEU_r28_nr.b36_fwd.txt" --out "genotypes_chrY_CEU_r28_nr.b36_fwd.txt" &
#
cd ~/PLINK/data/YRI
# impute sex
~/PLINK/plink-1.07-x86_64/plink --noweb --impute-sex --make-bed --file "genotypes_chrX_YRI_r28_nr.b36_fwd.txt" --out "genotypes_chrX_YRI_r28_nr.b36_fwd.txt" 
#
# check imputed sex
cut -f 1,5 -d ' ' genotypes_chrX_YRI_r28_nr.b36_fwd.txt.fam | sort > tmp1.txt
awk '{print $2" "$1}' ../hapmap_samples_individuals_filtered_by_coriell_ids_and_founders/pedinfo2sample_YRI_2.txt | sort > tmp2.txt
join -j 1 tmp1.txt tmp2.txt > tmp3.txt
cat tmp3.txt | grep -v "1 1" | grep -v "2 2" # should be empty
#
# make other binary files
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 Y
do
  ~/PLINK/plink-1.07-x86_64/plink --noweb --make-bed --file "genotypes_chr"$c"_YRI_r28_nr.b36_fwd.txt" --out "genotypes_chr"$c"_YRI_r28_nr.b36_fwd.txt" 
done
rm tmp4.txt
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 Y
do
  cut -f 1 -d ' ' "genotypes_chr"$c"_YRI_r28_nr.b36_fwd.txt.fam" > tmp1.txt
  cut -f 1 -d ' ' genotypes_chrX_YRI_r28_nr.b36_fwd.txt.fam > tmp2.txt
  diff tmp1.txt tmp2.txt >> tmp4.txt
done
cat tmp4.txt # should be empty
#
# copy across fam files
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 Y
do
  cp genotypes_chrX_YRI_r28_nr.b36_fwd.txt.fam "genotypes_chr"$c"_YRI_r28_nr.b36_fwd.txt.fam"
done
rm *.nosex
#
# get rid of females from Y chromosome file
~/PLINK/plink-1.07-x86_64/plink --noweb --filter-males --make-bed --bfile "genotypes_chrY_YRI_r28_nr.b36_fwd.txt" --out "genotypes_chrY_YRI_r28_nr.b36_fwd.txt" &
#
cd ~/PLINK/data/JPT
# impute sex
~/PLINK/plink-1.07-x86_64/plink --noweb --impute-sex --make-bed --file "genotypes_chrX_JPT_r28_nr.b36_fwd.txt" --out "genotypes_chrX_JPT_r28_nr.b36_fwd.txt" 
#
# check imputed sex
cut -f 1,5 -d ' ' genotypes_chrX_JPT_r28_nr.b36_fwd.txt.fam | sort > tmp1.txt
awk '{print $2" "$1}' ../hapmap_samples_individuals_filtered_by_coriell_ids_and_founders/pedinfo2sample_JPT_2.txt | sort > tmp2.txt
join -j 1 tmp1.txt tmp2.txt > tmp3.txt
cat tmp3.txt | grep -v "1 1" | grep -v "2 2" # should be empty
#
# make other binary files
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 Y
do
  ~/PLINK/plink-1.07-x86_64/plink --noweb --make-bed --file "genotypes_chr"$c"_JPT_r28_nr.b36_fwd.txt" --out "genotypes_chr"$c"_JPT_r28_nr.b36_fwd.txt" 
done
rm tmp4.txt
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 Y
do
  cut -f 1 -d ' ' "genotypes_chr"$c"_JPT_r28_nr.b36_fwd.txt.fam" > tmp1.txt
  cut -f 1 -d ' ' genotypes_chrX_JPT_r28_nr.b36_fwd.txt.fam > tmp2.txt
  diff tmp1.txt tmp2.txt >> tmp4.txt
done
cat tmp4.txt # should be empty
#
# copy across fam files
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 Y
do
  cp genotypes_chrX_JPT_r28_nr.b36_fwd.txt.fam "genotypes_chr"$c"_JPT_r28_nr.b36_fwd.txt.fam"
done
rm *.nosex
#
# get rid of females from Y chromosome file
~/PLINK/plink-1.07-x86_64/plink --noweb --filter-males --make-bed --bfile "genotypes_chrY_JPT_r28_nr.b36_fwd.txt" --out "genotypes_chrY_JPT_r28_nr.b36_fwd.txt" &
#
cd ~/PLINK/data/CHB
# impute sex
~/PLINK/plink-1.07-x86_64/plink --noweb --impute-sex --make-bed --file "genotypes_chrX_CHB_r28_nr.b36_fwd.txt" --out "genotypes_chrX_CHB_r28_nr.b36_fwd.txt" 
#
# check imputed sex
cut -f 1,5 -d ' ' genotypes_chrX_CHB_r28_nr.b36_fwd.txt.fam | sort > tmp1.txt
awk '{print $2" "$1}' ../hapmap_samples_individuals_filtered_by_coriell_ids_and_founders/pedinfo2sample_CHB_2.txt | sort > tmp2.txt
join -j 1 tmp1.txt tmp2.txt > tmp3.txt
cat tmp3.txt | grep -v "1 1" | grep -v "2 2" # should be empty
# maunally eidted ambiguous case NA18540 0 2
#
# make other binary files
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 Y
do
  ~/PLINK/plink-1.07-x86_64/plink --noweb --make-bed --file "genotypes_chr"$c"_CHB_r28_nr.b36_fwd.txt" --out "genotypes_chr"$c"_CHB_r28_nr.b36_fwd.txt" 
done
rm tmp4.txt
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 Y
do
  cut -f 1 -d ' ' "genotypes_chr"$c"_CHB_r28_nr.b36_fwd.txt.fam" > tmp1.txt
  cut -f 1 -d ' ' genotypes_chrX_CHB_r28_nr.b36_fwd.txt.fam > tmp2.txt
  diff tmp1.txt tmp2.txt >> tmp4.txt
done
cat tmp4.txt # should be empty
#
# copy across fam files
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 Y
do
  cp genotypes_chrX_CHB_r28_nr.b36_fwd.txt.fam "genotypes_chr"$c"_CHB_r28_nr.b36_fwd.txt.fam"
done
rm *.nosex
#
# get rid of females from Y chromosome file
~/PLINK/plink-1.07-x86_64/plink --noweb --filter-males --make-bed --bfile "genotypes_chrY_CHB_r28_nr.b36_fwd.txt" --out "genotypes_chrY_CHB_r28_nr.b36_fwd.txt" &
#
# merge hapmap samples CEU, YRI, JPT, CHB
cd ~/PLINK/data
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22
do
  rm allfiles.txt
  echo "JPT/genotypes_chr"$c"_JPT_r28_nr.b36_fwd.txt.bed" "JPT/genotypes_chr"$c"_JPT_r28_nr.b36_fwd.txt.bim" "JPT/genotypes_chr"$c"_JPT_r28_nr.b36_fwd.txt.fam" >> allfiles.txt
 echo "YRI/genotypes_chr"$c"_YRI_r28_nr.b36_fwd.txt.bed" "YRI/genotypes_chr"$c"_YRI_r28_nr.b36_fwd.txt.bim" "YRI/genotypes_chr"$c"_YRI_r28_nr.b36_fwd.txt.fam" >> allfiles.txt
 echo "CHB/genotypes_chr"$c"_CHB_r28_nr.b36_fwd.txt.bed" "CHB/genotypes_chr"$c"_CHB_r28_nr.b36_fwd.txt.bim" "CHB/genotypes_chr"$c"_CHB_r28_nr.b36_fwd.txt.fam" >> allfiles.txt
  ~/PLINK/plink-1.07-x86_64/plink --noweb --bfile "CEU/genotypes_chr"$c"_CEU_r28_nr.b36_fwd.txt" --merge-list allfiles.txt --make-bed --out "all/genotypes_chr"$c"_all_r28_nr.b36_fwd.txt" &
done
# cannot merge the files at this point, due to strand issue
#
###########################################
#
# cross merge hapmap samples YRI, JPT, CHB with CEU
cd ~/PLINK/data
for g in JPT CHB YRI
do 
  mkdir "CEU-"$g
  for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22
  do
    echo $g"/genotypes_chr"$c"_"$g"_r28_nr.b36_fwd.txt.bed" $g"/genotypes_chr"$c"_"$g"_r28_nr.b36_fwd.txt.bim" $g"/genotypes_chr"$c"_"$g"_r28_nr.b36_fwd.txt.fam" >> "CEU-"$g"/merging_files.txt"
    ~/PLINK/plink-1.07-x86_64/plink --noweb --bfile "CEU/genotypes_chr"$c"_CEU_r28_nr.b36_fwd.txt" --merge-list "CEU-"$g"/merging_files.txt" --make-bed --out "CEU-"$g"/genotypes_chr"$c"_all_r28_nr.b36_fwd.txt"
    rm "CEU-"$g"/merging_files.txt"
  done
  #
  # flip dna strand for missing snps
  cd ~/PLINK/data
  mkdir $g"_strand_flipped"
  for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22
  do
    ~/PLINK/plink-1.07-x86_64/plink --noweb --bfile $g"/genotypes_chr"$c"_"$g"_r28_nr.b36_fwd.txt" --flip "CEU-"$g"/genotypes_chr"$c"_all_r28_nr.b36_fwd.txt.missnp" --make-bed --out $g"_strand_flipped/genotypes_chr"$c"_"$g"_r28_nr.b36_fwd.txt"
  done
  #
  # re-cross merge hapmap samples
  cd ~/PLINK/data
  mkdir "CEU-"$g"_strand_flipped"
  for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 
  do
    echo $g"_strand_flipped/genotypes_chr"$c"_"$g"_r28_nr.b36_fwd.txt.bed" $g"_strand_flipped/genotypes_chr"$c"_"$g"_r28_nr.b36_fwd.txt.bim" $g"_strand_flipped/genotypes_chr"$c"_"$g"_r28_nr.b36_fwd.txt.fam" >> "CEU-"$g"_strand_flipped/merging_files.txt"
    ~/PLINK/plink-1.07-x86_64/plink --noweb --bfile "CEU/genotypes_chr"$c"_CEU_r28_nr.b36_fwd.txt" --merge-list "CEU-"$g"_strand_flipped/merging_files.txt" --make-bed --out "CEU-"$g"_strand_flipped/genotypes_chr"$c"_all_r28_nr.b36_fwd.txt"
    rm "CEU-"$g"_strand_flipped/merging_files.txt"
  done
done

# merge all hapmap samples: CEU, and the flipped-stand versions of YRI, JPT, CHB
cd ~/PLINK/data
mkdir "CEU_with_all_flipped_strand_groups"
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22
do
  echo "JPT_strand_flipped/genotypes_chr"$c"_JPT_r28_nr.b36_fwd.txt.bed" "JPT_strand_flipped/genotypes_chr"$c"_JPT_r28_nr.b36_fwd.txt.bim" "JPT_strand_flipped/genotypes_chr"$c"_JPT_r28_nr.b36_fwd.txt.fam" >> CEU_with_all_flipped_strand_groups/merging_files.txt
  echo "YRI_strand_flipped/genotypes_chr"$c"_YRI_r28_nr.b36_fwd.txt.bed" "YRI_strand_flipped/genotypes_chr"$c"_YRI_r28_nr.b36_fwd.txt.bim" "YRI_strand_flipped/genotypes_chr"$c"_YRI_r28_nr.b36_fwd.txt.fam" >> CEU_with_all_flipped_strand_groups/merging_files.txt
  echo "CHB_strand_flipped/genotypes_chr"$c"_CHB_r28_nr.b36_fwd.txt.bed" "CHB_strand_flipped/genotypes_chr"$c"_CHB_r28_nr.b36_fwd.txt.bim" "CHB_strand_flipped/genotypes_chr"$c"_CHB_r28_nr.b36_fwd.txt.fam" >> CEU_with_all_flipped_strand_groups/merging_files.txt
  ~/PLINK/plink-1.07-x86_64/plink --noweb --bfile "CEU/genotypes_chr"$c"_CEU_r28_nr.b36_fwd.txt" --merge-list CEU_with_all_flipped_strand_groups/merging_files.txt --make-bed --out "CEU_with_all_flipped_strand_groups/genotypes_chr"$c"_all_r28_nr.b36_fwd.txt"
  rm CEU_with_all_flipped_strand_groups/merging_files.txt
done
#
###########################################
#

#
# remove X chromosome SNPs with strand problem
cd ~/PLINK/data
for p in CEU YRI JPT CHB
do
  ~/PLINK/plink-1.07-x86_64/plink --noweb --bfile $p"/genotypes_chrX_"$p"_r28_nr.b36_fwd.txt" --exclude all/genotypes_chrX_all_r28_nr.b36_fwd.txt.missnp --make-bed --out $p"/genotypes_chrX_"$p"_r28_nr.b36_fwd.txt" &
done
#
# problem cannot be easily resolved
# we will ignore sex chromosomes as all of our genes of interest are autosomal
#
#
# look at missingness and allele freqs
cd ~/PLINK/data/all
for c in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 
do
  ~/PLINK/plink-1.07-x86_64/plink --noweb --bfile "genotypes_chr"$c"_all_r28_nr.b36_fwd.txt" --missing  --out "genotypes_chr"$c"_all_r28_nr.b36_fwd.txt" &
  ~/PLINK/plink-1.07-x86_64/plink --noweb --bfile "genotypes_chr"$c"_all_r28_nr.b36_fwd.txt" --freq --out "genotypes_chr"$c"_all_r28_nr.b36_fwd.txt" &
done

