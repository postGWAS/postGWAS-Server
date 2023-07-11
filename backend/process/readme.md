# Analysis pipeline
In general, nine methods are provided in this , including FUSION, CAVIAR, CAVIARBF, PAINTOR, FINEMAP, eCAVIAR, coloc, fastENLOC, and S-PrediXcan.
To run these analysis, you should download the relevant software package first.
## R interfaces:
+ FINEMAP <http://www.christianbenner.com/>
+ CAVIAR <https://github.com/fhormoz/caviar>
+ CAVIARBF <https://bitbucket.org/Wenan/caviarbf/src/master/>
+ PAINTOR <https://github.com/gkichaev/PAINTOR_V3.0>
+ COLOC <https://chr1swallace.github.io/coloc/>
+ eCAVIAR <https://github.com/fhormoz/caviar>
+ fastENLOC <https://github.com/xqwen/fastenloc/tree/master/tutorial>
+ FUSION <http://gusevlab.org/projects/fusion/>
+ S-PrediXcan <https://github.com/hakyimlab/MetaXcan>
# Usage
```
Rscript finemap.R [OPTIONS]
Options:
  -g, --gwas character     GWAS Input File
  --ld character           Input ld Matrix
  --beta character         the beta column of GWAS Input File
  --rsID character         the rs_id column of GWAS Input File
  --chr character          the chromosome column of GWAS Input File
  --pos character          the position column of GWAS Input File
  --A1 character           the allele1 column of the GWAS Input File
  --A2 character           the allele2 column of the GWAS Input File
  --maf character          the maf column of the GWAS Input File
  --se character           the se column of the GWAS Input File
  -c, --maxCasual integer  the maximal number of causal variants in the model
  --jobID character        job id
```

```
Rscript caviar.R [OPTIONS]
Options:
  -g, --gwas character     GWAS Input File
  --ld character           Input ld Matrix
  -c, --maxCasual integer  the maximal number of causal variants in the model
  --zsocre character       The zscore column of GWAS input file
  --rsID character         The rs_id column of GWAS input file
  --jobID character        job id
```

```
Rscript caviarBF.R [OPTIONS]
Options:
  -g, --gwas character     GWAS Input File
  --ld character           Input ld Matrix
  --jobID character        job id
  -c, --maxCasual integer  the maximal number of causal variants in the model
  --zsocre character       The zscore column of GWAS input file
  --rsID character         The rs_id column of GWAS input file
```

```
Rscript paintor.R [OPTIONS]
Options:
  -g, --gwas character     GWAS Input File
  --ld character           Input ld Matrix
  -a, --args character     additional arguments
  --annots character       Functional Annotation Matrix
  --annotations character  The names of the annotations to include in model
  --zsocre character       The zscore column of GWAS input file
  --rsID character         The rs_id column of GWAS input file
  --jobID character        job id
```

```
Rscript coloc.R [OPTIONS]
Options:
  -g, --gwas character     GWAS Input File
  -e, --eQTL character     eQTL Input File
  --rsID character         The rs_id column of GWAS input file
  --pval character         The pvalue column of GWAS input file
  --beta character         The beta column of GWAS input file
  --varbeta character      The varbeta column of GWAS input file
  --ersID character        The rs_id column of eQTL input file
  --epval character        The pvalue column of eQTL input file
  --emaf character         The minor allele frequency column of eQTL input file
  --geneID character       The gene id column of eQTL input file
  --threshold numeric      Posterior probabilities of H4 above this threshold were considered colocalization signals
  --flag integer           1 indicates using GTex v8 eQTL data; 0 indicates using your own eQTL data
  -t, --tissue character   specify the tissue name
  --jobID character        job id
```

```
Rscript ecaviar.R [OPTIONS]
Options:
  -g, --gwas character     GWAS Input File
  --ld character           Input ld Matrix
  -c, --maxCasual integer  the maximal number of causal variants in the model
  -e, --eQTL character     eQTL Input File
  --eQTLld character       The eQTL ld input file
  --zsocre character       The zscore column of GWAS input file
  --rsID character         The rs_id column of GWAS input file
  --ezscore character      The zscore column of eQTL input file
  --ersID character        The rs_id column of eQTL input file
  --jobID character        job id
```

```
Rscript fastenloc.R [OPTIONS]
Options:
  -g, --gwas character     GWAS Input File
  -e, --eQTL character     eQTL Input File
  -t, --tissue character   specify the tissue name
  --prefix character       specify the prefix for the output files
  --zsocre character       The zscore column of GWAS input file
  --rsID character         The rs_id column of GWAS input file
  --locID character        The loc_id column of GWAS input file
  --variantID character    The variant_id column of GWAS input file
  --GRCP numeric           Threshold of GRCP
  --GLCP numeric           Threshold of GLCP
  --RCP numeric            Threshold of RCP
  --jobID character        job id
  --flag integer           1 indicates Multi-tissue eQTL annotation with hg38 position ID; 2 indicates Multi-tissue eQTL annotation with rs ID; 0 indicates using your own eQTL annotation
```

```
Rscript fusion.R [OPTIONS]
Options:
  -g, --gwas character     GWAS Input File
  -t, --tissue character   specify the tissue name
  --zsocre character       The zscore column of GWAS input file
  --rsID character         The rs_id column of GWAS input file
  --A1 character           first allele (effect allele)
  --A2 character           second allele (other allele)
  --chr integer            Chromosome
  --model character        Gene expression models to run. Options: blup,lasso,top1,enet.
  --threshold numeric      The threshold of TWAS P value.
  --jobID character        job id
```

```
Rscript S-prediXcan.R [OPTIONS]
Options:
  -g, --gwas character     GWAS Input File
  -t, --tissue character   specify the tissue name
  --rsID character         The rs_id column of GWAS input file
  --zsocre character       The zscore column of GWAS input file
  --A1 character           first allele (effect allele)
  --A2 character           second allele (other allele)
  --chr integer            Chromosome
  --pos character          The position column of GWAS input file
  --flag integer           1 indicates GWAS summary statistics with rs ID; 0 indicates GWAS summary statistics with hg38 position ID
  --jobID character        job id
  --model character        Select the desired prediction model(mashr or enet)
```
# Example
```

Rscript finemap.R -g example/data.z --ld example/data.ld --beta beta --rsID rsid --chr chromosome --pos position --A1 allele1 --A2 allele2 --maf maf --se se --ng 5363

Rscript caviar.R -g ./sample_data/50_Z.txt --ld ./sample_data/50_LD.txt --zscore zscore --rsID rsid -c 6 --jobID 101

Rscript caviarBF.R -g ./example/myfile.Z --ld ./example/myfile.LD --jobID 101 -c 5 --zscore zscore --rsID rs_id --ng 2000

Rscript paintor.R --gwas SampleData/Locus1 --ld SampleData/Locus1.ld --annots SampleData/Locus1.annotations --annotations DHS --zscore Zscore --args="-enumerate 1"

Rscript coloc.R -g ./GWAS.txt -e ./eQTL.txt --ng 50000 --ne 10000 --rsID rs_id --pval pval --beta beta --varbeta varbeta --geneID gene_id --ersID rs_id --emaf maf --epval pval --threshold 0.95 --jobID 20230421

Rscript ecaviar.R -g ./sample_data/GWAS.MC.AD.IGAP.stage1.hg19.chr.11.121344805.121517613.CHRPOSREFALT.Z.txt --ld ./sample_data/GWAS.ADGC.MC.AD.IGAP.stage1.hg19.chr.11.121344805.121517613.CHRPOSREFALT.LD.ld -e ./sample_data/eQTL.CARDIOGENICS.MC.AD.IGAP.stage1.hg19.chr.11.121344805.121517613.CHRPOSREFALT.ILMN_1810712.NM_015313.1.ARHGEF12.Z.txt --eQTLld ./sample_data/eQTL.CARDIOGENICS.MC.AD.IGAP.stage1.hg19.chr.11.121344805.121517613.CHRPOSREFALT.LD.ld --zscore zscore --rsID rs_id --ezscore zscore --ersID rs_id -c 4

Rscript fastenloc.R -g ./Height.torus.zval.gz -t Whole_Blood --prefix Height_Blood --zscore zscore --locID locid --variantID variantid --flag 1

Rscipt fusion.R -g ./fusionGWAS.txt.gz -t Whole_Blood --zscore zscore --rsID rs_id --A1 effect_allele --A2 non_effect_allele --chr 22 --jobID 20235555 --model lasso

Rscript S-PrediXcan.R -g ./CARDIoGRAM_C4D_CAD.txt.gz -t Whole_Blood --zscore zscore --rsID rs_id --A1 effect_allele --A2 non_effect_allele --chr chromosome --pos position --flag 1 --model mashr --jobID 2222222
```
