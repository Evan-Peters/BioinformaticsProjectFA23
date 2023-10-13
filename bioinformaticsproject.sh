#Make sure you are in the BioinformaticsProjectFA23 directory before using this bash script!
#usage: bash bioinformaticsproject.sh

#creates 2 files containing each gene type
cat ref_sequences/hsp70gene*.fasta>hsp70genes
cat ref_sequences/mcrAgene*.fasta>mcrAgenes
#aligns all sequences of both gene types separately and creates new files for them
~/Private/Biocomputing/tools/muscle -align hsp70genes -output hsp70genes_aligned
~/Private/Biocomputing/tools/muscle -align mcrAgenes -output mcrAgenes_aligned
#creates .hmm files for both aligned gene files
~/Private/Biocomputing/tools/hmmbuild hsp70genes.hmm hsp70genes_aligned
~/Private/Biocomputing/tools/hmmbuild mcrAgenes.hmm mcrAgenes_aligned
#creates a table with labels for each column
touch table.csv
echo "proteome , hsp70count , mcrAcount" >> table.csv
#completes the table with number of matches for both gene types
for file in proteomes/*.fasta
do
~/Private/Biocomputing/tools/hmmsearch --tblout hsp70.output hsp70genes.hmm $file
~/Private/Biocomputing/tools/hmmsearch --tblout mcrA.output mcrAgenes.hmm $file
hsp70count=$(cat hsp70.output | grep -v "#" | wc -l)
mcrAcount=$(cat mcrA.output | grep -v "#" | wc -l)
proteomenumber=$(echo $file | sed 's/proteomes\///;s/\.fasta$//')
echo $proteomenumber , $hsp70count , $mcrAcount >> table.csv
done
#creates a file containing the proteomes of interest (contains both mcrA gene and hsp70 gene)
cat table.csv | grep -v ", 0" | cut -d , -f 1 >> proteomesofinterest.csv
