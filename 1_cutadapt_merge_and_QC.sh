source ~/.bashrc
source activate qiime1

fwdprimer=GTGYCAGCMGCCGCGGTAA
revprimer=GGACTACNVGGGTWTCTAAT

indir=/raid1/home/micro/klingesj/grace/miseqmay17bm

mkdir -p ${indir}/merged/
mkdir -p ${indir}/trimmed/

for file in ${indir}/*.fastq; do
    new=${file//_/.}
    new1=${new//.S[0-9]*.R1/_R1}
    new2=${new1//.S[0-9]*.R2/_R2}
    new3=${new2#*-*-*-*-*-*-}
    new4=${new3//.001.fastq/}
    mv ${file} ${new4}    
done

# for file in ${indir}/*.fastq; do    
#     mv ${file} ${file//.S[0-9]*.R1/_R1}
# done    
   
# for file in ${indir}/*.fastq; do    
#     mv ${file} ${file//.S[0-9]*.R2/_R2}
# done

# for file in ${indir}/*.fastq; do  
#     new=${file#*-*-*-*-*-}
#     mv ${file} ${new}
# done

# for file in ${indir}/*.fastq; do  
#     mv ${file} ${file//.001.fastq/}
# # done

# for file in ${indir}/*_R1; do
#   new=${file}.fastq
#     mv ${file} ${new}
# done

# for file in ${indir}/*_R2; do
#   new=${file}.fastq
#     mv ${file} ${new}
# done


for file in ${indir}/*_R1*; do
     filename=$(basename $file)
     sampleid=${filename/_*}

     #cutadapt params=
      #-g ^ADAPTER = Anchored 5’ adapter
      #-G ^ADAPTER = Same anchored 5' adapter is searched for in the second read

cutadapt --discard-untrimmed -g "^${fwdprimer}" -G "^${revprimer}" -o ${indir}/trimmed/${sampleid}_R1 -p ${indir}/trimmed/${sampleid}_R2 ${file} ${file/R1/R2}

vsearch --fastq_mergepairs ${indir}/trimmed/${sampleid}_R1 --reverse ${indir}/trimmed/${sampleid}_R2 --fastq_allowmergestagger --fasta_width 0 --threads 5 --fastqout ${file}_merged.fq

done

#remove _R1 from read names
for file in ${indir}/*_R1.fastq_merged.fq; do
    mv ${file} ${file/_R1.fastq_merged.fq/_merged.fq}
done

mv ${indir}/*_merged.fq ${indir}/merged 
rm ${indir}/merged/*_R1.fastq_merged.fq
  
## filter merged reads based on 'expected errors' and a minimum read length. QIIME's method of filtering (which would take place during split_libraries) truncates reads based on the idea that quality gradually diminishes along the read. however, this assumption isn't true for reads that have been merged. This usearch function instead determines the likelihood that each read has an error based on all the quality scores, and if that likelihood passes a certain threshold, throws out the entire read.

mkdir -p ${indir}/filtered/

for file in ${indir}/merged/*.fq; do
   filename=$(basename $file)
   sampleid=${filename/_*}

vsearch --fastq_filter "${file}" --fastq_maxns 1 --fastq_maxee 1 --fastq_ascii 33 --fasta_width 0 -fastq_minlen 100 --threads 5 --fastaout ${indir}/filtered/${sampleid}.fasta

mkdir -p ${indir}/filtered_220/

done

##second filtering step to 220 to remove mitochondria
for file in ${indir}/merged/*.fq; do
   filename=$(basename $file)
   sampleid=${filename/_*}

vsearch --fastq_filter "${file}" --fastq_maxns 1 --fastq_maxee 1 --fastq_ascii 33 --fasta_width 0 -fastq_minlen 220 --threads 5 --fastaout ${indir}/filtered_220/${sampleid}.fasta

cat ${indir}/filtered/*.fasta > ${indir}/seqs.fna
cat ${indir}/filtered_220/*.fasta > ${indir}/seqs_220.fna
done