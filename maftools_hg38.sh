#!/usr/bin/sh
#SBATCH -A MST109178        # Account name/project number
#SBATCH -J SAMPLE_NAME         # Job name
#SBATCH -p ngs48G           # Partition Name 
#SBATCH -c 14               # Core numbers
#SBATCH --mem=46g           # Memory size
#SBATCH -o out.log          # Path to the standard output file 
#SBATCH -e err.log          # Path to the standard error ouput file
#SBATCH --mail-user=@gmail.com    # email
#SBATCH --mail-type=FAIL              # When to send an email = NONE, BEGIN, END, FAIL, REQUEUE, or ALL


table_annovar='/opt/ohpc/Taiwania3/pkg/biology/ANNOVAR/annovar_20210819/table_annovar.pl'
input_vcf='260_BigPanel.vcf'
para="260_BigPanel"
humandb="/staging/reserve/paylong_ntu/AI_SHARE/reference/annovar_2016Feb01/humandb/"


TIME=`date +%Y%m%d%H%M`
logfile=./${TIME}run.log
exec 3<&1 4<&2
exec >$logfile 2>&1
set -euo pipefail
set -x 

#hg38 version
perl ${table_annovar} ${input_vcf} ${humandb} -buildver hg38 -out ${para} -remove -protocol refGene,cytoBand,knownGene,ensGene,gnomad30_genome,avsnp150,gnomad211_exome,intervar_20180118,clinvar_20210501,dbnsfp41a,icgc28,revel -vcfinput -operation gx,r,gx,gx,f,f,f,f,f,f,f,f -nastring . 



# transfer ANNOVAR to maftools
module add pkg/Anaconda3

python annovar_to_maftools_input.py -i ${para}.hg38_multianno.txt -o ${para}.hg38.maftools.txt
