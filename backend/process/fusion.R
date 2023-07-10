library('optparse')
library(dplyr)
if (!requireNamespace("readr", quietly = TRUE))
  install.packages("readr")
library(readr)
if (!requireNamespace("magrittr", quietly = TRUE))
  install.packages("magrittr")
library(magrittr)

option_list<- list(
  make_option(c("-g", "--gwas"), type = "character",  default = NULL,
              help = "specify the prepared GWAS file [default \"%default\"]"),
  make_option(c("-t", "--tissue"), type = "character",  default = "Whole_Blood",
              help = "specify the tissue name [default \"%default\"]"),
  make_option("--args", type = "character", default = NULL,
              help = "additional arguments [default \"%default\"]"),
  make_option("--zscore", type = "character", default = NULL,
              help = "The zscore column of GWAS input file [default \"%default\"]"),
  make_option("--rsID", type = "character", default = NULL,
              help = "The rs_id column of GWAS input file [default \"%default\"]"),
  make_option("--A1", type = "character", default = NULL,
              help = "first allele (effect allele) [default \"%default\"]"),
  make_option("--A2", type = "character", default = NULL,
              help = "second allele (other allele) [default \"%default\"]"),
  make_option("--chr", type = "integer", default = NULL,
              help = "Chromosome [default \"%default\"]"),
  make_option("--model", type = "character", default = "lasso",
              help = "Gene expression models to run. Options: blup,lasso,top1,enet. [default \"%default\"]"),
  make_option("--threshold", type = "numeric", default = 0.01,
              help = "the threshold of TWAS P value. [default \"%default\"]"),
  make_option("--jobID", type = "character", default = NULL,
              help = "job id [default \"%default\"]")
)

opt_parser <- OptionParser(option_list=option_list) #解析参数

opt <- parse_args(opt_parser) #解析参数
gp <- opt$gwas
tissue <- opt$tissue
arg <- opt$args
rs_id <- opt$rsID
zscore <- opt$zscore
A1 <- opt$A1
A2 <- opt$A2
chr <- as.numeric(opt$chr)
threshold <- as.numeric(opt$threshold)
job_id <- opt$jobID
model <- opt$model

stopifnot(file.exists(gp))
stopifnot(chr >= 1 & chr <= 22)

# read the file
myGWAS <- read.table(file = gp, header = T)

# SNP identifier
print(rs_id)
print(colnames(myGWAS))
stopifnot(rs_id %in% colnames(myGWAS))
# first allele
stopifnot(A1 %in% colnames(myGWAS))
# second allele
stopifnot(A2 %in% colnames(myGWAS))
# Z-scores, sign with respect to A1
# Additional columns are allowed and will be ignored.
stopifnot(zscore %in% colnames(myGWAS))

# filter the required data
myGWAS <- myGWAS %>% select(c(all_of(rs_id), all_of(zscore), A1, A2))
names(myGWAS)[c(1, 2, 3, 4)] <- c("SNP", "Z", "A1", "A2")

# Quality Control
myGWAS <- filter(myGWAS, !is.na(Z))

# Prepare input files
weight <- switch(tissue, Adipose_Subcutaneous = "./WEIGHTS/GTEx.Adipose_Subcutaneous/GTExv8.EUR.Adipose_Subcutaneous.pos",
                 Adipose_visceral_Omentum = "./WEIGHTS/GTEx.Adipose_visceral_Omentum/GTExv8.EUR.Adipose_visceral_Omentum.pos",
                 Adrenal_Gland = "./WEIGHTS/GTEx.Adrenal_Gland/GTExv8.EUR.Adrenal_Gland.pos",
                 Artery_Aorta = "./WEIGHTS/GTEx.Artery_Aorta/GTExv8.EUR.Artery_Aorta.pos",
                 Artery_Coronary = "./WEIGHTS/GTEx.Artery_Coronary/GTExv8.EUR.Artery_Coronary.pos",
                 Artery_Tibial = "./WEIGHTS/GTEx.Artery_Tibial/GTExv8.EUR.Artery_Tibial.pos",
                 Brain_Amygdala = "./WEIGHTS/GTEx.Brain_Amygdala/GTExv8.EUR.Brain_Amygdala.pos",
                 Brain_Anterior_cingulate_cortex_BA24 = "./WEIGHTS/GTEx.Brain_Anterior_cingulate_cortex_BA24/GTExv8.EUR.Brain_Anterior_cingulate_cortex_BA24.pos",
                 Brain_Caudate_basal_ganglia = "./WEIGHTS/GTEx.Brain_Caudate_basal_ganglia/GTExv8.EUR.Brain_Caudate_basal_ganglia.pos",
                 Brain_Cerebellar_Hemisphere = "./WEIGHTS/GTEx.Brain_Cerebellar_Hemisphere/GTExv8.EUR.Brain_Cerebellar_Hemisphere.pos",
                 Brain_Cerebellum = "./WEIGHTS/GTEx.Brain_Cerebellum/GTExv8.EUR.Brain_Cerebellum.pos",
                 Brain_Cortex = "./WEIGHTS/GTEx.Brain_Cortex/GTExv8.EUR.Brain_Cortex.pos",
                 Brain_Frontal_Cortex_BA9 = "./WEIGHTS/GTEx.Brain_Frontal_Cortex_BA9/GTExv8.EUR.Brain_Frontal_Cortex_BA9.pos",
                 Brain_Hippocampus = "./WEIGHTS/GTEx.Brain_Hippocampus/GTExv8.EUR.Brain_Hippocampus.pos",
                 Brain_Hypothalamus = "./WEIGHTS/GTEx.Brain_Hypothalamus/GTExv8.EUR.Brain_Hypothalamus.pos",
                 Brain_Nucleus_accumbens_basal_ganglia = "./WEIGHTS/GTEx.Brain_Nucleus_accumbens_basal_ganglia/GTExv8.EUR.Brain_Nucleus_accumbens_basal_ganglia.pos",
                 Brain_Putamen_basal_ganglia = "./WEIGHTS/GTEx.Brain_Putamen_basal_ganglia/GTExv8.EUR.Brain_Putamen_basal_ganglia.pos",
                 Brain_Spinal_cord_cervical_c_1 = "./WEIGHTS/GTEx.Brain_Spinal_cord_cervical_c-1/GTExv8.EUR.Brain_Spinal_cord_cervical_c-1.pos",
                 Brain_Substantia_nigra = "./WEIGHTS/GTEx.Brain_Substantia_nigra/GTExv8.EUR.Brain_Substantia_nigra.pos",
                 Breast_Mammary_Tissue = "./WEIGHTS/GTEx.Breast_Mammary_Tissue/GTExv8.EUR.Breast_Mammary_Tissue.pos",
                 Cells_Cultured_fibroblasts = "./WEIGHTS/GTEx.Cells_Cultured_fibroblasts/GTExv8.EUR.Cells_Cultured_fibroblasts.pos",
                 Cells_EBV_transformed_lymphocytes = "./WEIGHTS/GTEx.Cells_EBV-transformed_lymphocytes/GTExv8.EUR.Cells_EBV-transformed_lymphocytes.pos",
                 Colon_Sigmoid = "./WEIGHTS/GTEx.Colon_Sigmoid/GTExv8.EUR.Colon_Sigmoid.pos",
                 Colon_Transverse = "./WEIGHTS/GTEx.Colon_Transverse/GTExv8.EUR.Colon_Transverse.pos",
                 Esophagus_Gastroesophageal_Junction = "./WEIGHTS/GTEx.Esophagus_Gastroesophageal_Junction/GTExv8.EUR.Esophagus_Gastroesophageal_Junction.pos",
                 Esophagus_Mucosa = "./WEIGHTS/GTEx.Esophagus_Mucosa/GTExv8.EUR.Esophagus_Mucosa.pos",
                 Esophagus_Muscularis = "./WEIGHTS/GTEx.Esophagus_Muscularis/GTExv8.EUR.Esophagus_Muscularis.pos",
                 Heart_Atrial_Appendage = "./WEIGHTS/GTEx.Heart_Atrial_Appendage/GTExv8.EUR.Heart_Atrial_Appendage.pos",
                 Heart_Left_Ventricle = "./WEIGHTS/GTEx.Heart_Left_Ventricle/GTExv8.EUR.Heart_Left_Ventricle.pos",
                 Kidney_Cortex = "./WEIGHTS/GTEx.Kidney_Cortex/GTExv8.EUR.Kidney_Cortex.pos",
                 Liver = "./WEIGHTS/GTEx.Liver/GTExv8.EUR.Liver.pos",
                 Lung = "./WEIGHTS/GTEx.Lung/GTExv8.EUR.Lung.pos",
                 Minor_Salivary_Gland = "./WEIGHTS/GTEx.Minor_Salivary_Gland/GTExv8.EUR.Minor_Salivary_Gland.pos",
                 Muscle_Skeletal = "./WEIGHTS/GTEx.Muscle_Skeletal/GTExv8.EUR.Muscle_Skeletal.pos",
                 Nerve_Tibial = "./WEIGHTS/GTEx.Nerve_Tibial/GTExv8.EUR.Nerve_Tibial.pos",
                 Ovary = "./WEIGHTS/GTEx.Ovary/GTExv8.EUR.Ovary.pos",
                 Pancreas = "./WEIGHTS/GTEx.Pancreas/GTExv8.EUR.Pancreas.pos",
                 Pituitary = "./WEIGHTS/GTEx.Pituitary/GTExv8.EUR.Pituitary.pos",
                 Prostate = "./WEIGHTS/GTEx.Prostate/GTExv8.EUR.Prostate.pos",
                 Skin_Not_Sun_Exposed_Suprapubic = "./WEIGHTS/GTEx.Skin_Not_Sun_Exposed_Suprapubic/GTExv8.EUR.Skin_Not_Sun_Exposed_Suprapubic.pos",
                 Skin_Sun_Exposed_Lower_leg = "./WEIGHTS/GTEx.Skin_Sun_Exposed_Lower_leg/GTExv8.EUR.Skin_Sun_Exposed_Lower_leg.pos",
                 Small_Intestine_Terminal_Ileum = "./WEIGHTS/GTEx.Small_Intestine_Terminal_Ileum/GTExv8.EUR.Small_Intestine_Terminal_Ileum.pos",
                 Spleen = "./WEIGHTS/GTEx.Spleen/GTExv8.EUR.Spleen.pos",
                 Stomach = "./WEIGHTS/GTEx.Stomach/GTExv8.EUR.Stomach.pos",
                 Testis = "./WEIGHTS/GTEx.Testis/GTExv8.EUR.Testis.pos",
                 Vagina = "./WEIGHTS/GTEx.Vagina/GTExv8.EUR.Vagina.pos",
                 Whole_Blood = "./WEIGHTS/GTEx.Whole_Blood1/GTExv8.EUR.Whole_Blood.pos",
                 "Input Error!")

weight_dir <- switch(tissue, Adipose_Subcutaneous = "./WEIGHTS/GTEx.Adipose_Subcutaneous/",
                     Adipose_visceral_Omentum = "./WEIGHTS/GTEx.Adipose_visceral_Omentum/",
                     Adrenal_Gland = "./WEIGHTS/GTEx.Adrenal_Gland/",
                     Artery_Aorta = "./WEIGHTS/GTEx.Artery_Aorta/",
                     Artery_Coronary = "./WEIGHTS/GTEx.Artery_Coronary/",
                     Artery_Tibial = "./WEIGHTS/GTEx.Artery_Tibial/",
                     Brain_Amygdala = "./WEIGHTS/GTEx.Brain_Amygdala/",
                     Brain_Anterior_cingulate_cortex_BA24 = "./WEIGHTS/GTEx.Brain_Anterior_cingulate_cortex_BA24/",
                     Brain_Caudate_basal_ganglia = "./WEIGHTS/GTEx.Brain_Caudate_basal_ganglia/",
                     Brain_Cerebellar_Hemisphere = "./WEIGHTS/GTEx.Brain_Cerebellar_Hemisphere/",
                     Brain_Cerebellum = "./WEIGHTS/GTEx.Brain_Cerebellum/",
                     Brain_Cortex = "./WEIGHTS/GTEx.Brain_Cortex/",
                     Brain_Frontal_Cortex_BA9 = "./WEIGHTS/GTEx.Brain_Frontal_Cortex_BA9/",
                     Brain_Hippocampus = "./WEIGHTS/GTEx.Brain_Hippocampus/",
                     Brain_Hypothalamus = "./WEIGHTS/GTEx.Brain_Hypothalamus/",
                     Brain_Nucleus_accumbens_basal_ganglia = "./WEIGHTS/GTEx.Brain_Nucleus_accumbens_basal_ganglia/",
                     Brain_Putamen_basal_ganglia = "./WEIGHTS/GTEx.Brain_Putamen_basal_ganglia/",
                     Brain_Spinal_cord_cervical_c_1 = "./WEIGHTS/GTEx.Brain_Spinal_cord_cervical_c-1/",
                     Brain_Substantia_nigra = "./WEIGHTS/GTEx.Brain_Substantia_nigra/",
                     Breast_Mammary_Tissue = "./WEIGHTS/GTEx.Breast_Mammary_Tissue/",
                     Cells_Cultured_fibroblasts = "./WEIGHTS/GTEx.Cells_Cultured_fibroblasts/",
                     Cells_EBV_transformed_lymphocytes = "./WEIGHTS/GTEx.Cells_EBV-transformed_lymphocytes/",
                     Colon_Sigmoid = "./WEIGHTS/GTEx.Colon_Sigmoid/",
                     Colon_Transverse = "./WEIGHTS/GTEx.Colon_Transverse/",
                     Esophagus_Gastroesophageal_Junction = "./WEIGHTS/GTEx.Esophagus_Gastroesophageal_Junction/",
                     Esophagus_Mucosa = "./WEIGHTS/GTEx.Esophagus_Mucosa/",
                     Esophagus_Muscularis = "./WEIGHTS/GTEx.Esophagus_Muscularis/",
                     Heart_Atrial_Appendage = "./WEIGHTS/GTEx.Heart_Atrial_Appendage/",
                     Heart_Left_Ventricle = "./WEIGHTS/GTEx.Heart_Left_Ventricle/",
                     Kidney_Cortex = "./WEIGHTS/GTEx.Kidney_Cortex/",
                     Liver = "./WEIGHTS/GTEx.Liver/",
                     Lung = "./WEIGHTS/GTEx.Lung/",
                     Minor_Salivary_Gland = "./WEIGHTS/GTEx.Minor_Salivary_Gland/",
                     Muscle_Skeletal = "./WEIGHTS/GTEx.Muscle_Skeletal/",
                     Nerve_Tibial = "./WEIGHTS/GTEx.Nerve_Tibial/",
                     Ovary = "./WEIGHTS/GTEx.Ovary/",
                     Pancreas = "./WEIGHTS/GTEx.Pancreas/",
                     Pituitary = "./WEIGHTS/GTEx.Pituitary/",
                     Prostate = "./WEIGHTS/GTEx.Prostate/",
                     Skin_Not_Sun_Exposed_Suprapubic = "./WEIGHTS/GTEx.Skin_Not_Sun_Exposed_Suprapubic/",
                     Skin_Sun_Exposed_Lower_leg = "./WEIGHTS/GTEx.Skin_Sun_Exposed_Lower_leg/",
                     Small_Intestine_Terminal_Ileum = "./WEIGHTS/GTEx.Small_Intestine_Terminal_Ileum/",
                     Spleen = "./WEIGHTS/GTEx.Spleen/",
                     Stomach = "./WEIGHTS/GTEx.Stomach/",
                     Testis = "./WEIGHTS/GTEx.Testis/",
                     Vagina = "./WEIGHTS/GTEx.Vagina/",
                     Whole_Blood = "./WEIGHTS/GTEx.Whole_Blood1/",
                     "Input Error!")

dir_input <- paste0("dir_input_", job_id)
dir_run <- paste0("dir_fusion_", job_id)
dir_create <-  dir.create(file.path(getwd(), dir_run), showWarnings = FALSE,
                          recursive = TRUE)
dir_create <-  dir.create(file.path(getwd(), dir_input), showWarnings = FALSE,
                          recursive = TRUE)

ref_ld_chr <- "./LDREF/1000G.EUR."
write.table(myGWAS[,1:4], file.path(dir_input, "gwas.sumstats"),
            sep = " ", row.names = FALSE, col.names = TRUE, quote =FALSE)

# Run the method
tool_input <- paste0(" --sumstats ", file.path(dir_input, "gwas.sumstats")," --weights ", weight,
                     " --weights_dir ", weight_dir, " --ref_ld_chr ",
                     ref_ld_chr, " --chr ", chr, " --force_model ",  model," --out ", file.path(dir_run, "result.dat"))
if(!is.null(arg)){
  tool_input <- paste0(tool_input, " ", arg)
}
cmd <- paste("Rscript ./FUSION.assoc_test.R", tool_input)
print(cmd)

ret_run <- try({
  system(cmd, input = tool_input)
})
ret_status <- ifelse(ret_run == 0, TRUE, FALSE)
if(ret_status){
  if(!file.exists(file.path(dir_run,"result.dat"))){
    ret_status <- FALSE
  }
}
stopifnot(ret_status != 0)

res <- read.table(file.path(dir_run, "result.dat"), header=TRUE, sep="\t")
if(all(is.na(res$PANEL))) {
  stop("A large number of genes were skipped, and examine your GWAS zscores and tissue selected. Exiting program.")
}

# res <- res[, c("ID", "CHR", "P0", "P1", "BEST.GWAS.ID", "EQTL.ID","MODEL", "TWAS.Z", "TWAS.P")]
# write.table(res, file.path(dir_run, "result.dat"),
#             sep = " ", row.names = FALSE, col.names = TRUE, quote =FALSE)
catCMD <- paste0("cat ",file.path(dir_run, "result.dat"), " | awk 'NR == 1 || $NF < ", threshold, "' > ",file.path(dir_run, "result.top"))
print(catCMD)
cat_run <- try({
  system(catCMD)
})
catStatus <- ifelse(cat_run == 0, TRUE, FALSE)
stopifnot(catStatus != 0)

postProcessInput <- paste0("--sumstats ",file.path(dir_input, "gwas.sumstats"), " --input ",
                         file.path(dir_run, "result.top"), " --out ",
                         file.path(dir_run, "result.top.analysis")," --ref_ld_chr ",
                         "./LDREF/1000G.EUR. --chr ", chr," --plot --locus_win 100000")
postProcessCMD <- paste("Rscript FUSION.post_process.R", postProcessInput)
print(postProcessCMD)
postProcess_run <- try({
  system(postProcessCMD, input = postProcessInput)
})
postProcess_status <- ifelse(postProcess_run == 0, TRUE, FALSE)
stopifnot(postProcess_status != 0)
