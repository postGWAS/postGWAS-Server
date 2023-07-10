library('optparse')
library(dplyr)
if (!requireNamespace("readr", quietly = TRUE))
  install.packages("readr")
library(readr)
if (!requireNamespace("magrittr", quietly = TRUE))
  install.packages("magrittr")
library(magrittr)
library(data.table)
library(ggplot2)

option_list<- list(
  make_option(c("-g", "--gwas"), type = "character",  default = NULL,
              help = "specify the prepared GWAS file [default \"%default\"]"),
  make_option(c("-t", "--tissue"), type = "character",  default = "Whole_Blood",
              help = "specify the tissue name [default \"%default\"]"),
  make_option("--zscore", type = "character", default = "zscore",
              help = "The zscore column of GWAS input file [default \"%default\"]"),
  make_option("--rsID", type = "character", default = "rs_id",
              help = "The rs_id column of GWAS input file [default \"%default\"]"),
  make_option("--A1", type = "character", default = "A1",
              help = "first allele (effect allele) [default \"%default\"]"),
  make_option("--A2", type = "character", default = "A2",
              help = "second allele (other allele) [default \"%default\"]"),
  make_option("--chr", type = "character", default = "chromosome",
              help = "The chromosome column of GWAS input file [default \"%default\"]"),
  make_option("--pos", type = "character", default = "position",
              help = "The position column of GWAS input file [default \"%default\"]"),
  make_option("--flag", type = "integer", default = 0,
              help = "1 indicates GWAS summary statistics with rs ID;
              0 indicates GWAS summary statistics with hg38 position ID"),
  make_option("--jobID", type = "character", default = NULL,
              help = "job id [default \"%default\"]"),
  make_option("--model", type = "character", default = "mashr",
              help = "Select the desired prediction model(mashr or enet) [default \"%default\"]")
)

opt_parser <- OptionParser(option_list=option_list) #解析参数

opt <- parse_args(opt_parser) #解析参数
gp <- opt$gwas
tissue <- opt$tissue
rs_id <- opt$rsID
A1 <- opt$A1
A2 <- opt$A2
zscore <- opt$zscore
model <- opt$model
chr <- opt$chr
pos <- opt$pos
flag <- as.numeric(opt$flag)
job_id <- opt$jobID

stopifnot(file.exists(gp))
stopifnot(model == "mashr" | model == "enet")
stopifnot(flag == 1 | flag ==0)

# read the file
myGWAS <- fread(file = gp, header = T)

if(flag == 0){
  stopifnot(ncol(myGWAS) >= 4)
  stopifnot(rs_id %in% colnames(myGWAS))
  # effect allele
  stopifnot(A1 %in% colnames(myGWAS))
  # non effect allele
  stopifnot(A2 %in% colnames(myGWAS))
  stopifnot(zscore %in% colnames(myGWAS))
}else{
  stopifnot(ncol(myGWAS) >= 6)
  stopifnot(rs_id %in% colnames(myGWAS))
  # effect allele
  stopifnot(A1 %in% colnames(myGWAS))
  # non effect allele
  stopifnot(A2 %in% colnames(myGWAS))
  stopifnot(zscore %in% colnames(myGWAS))
  stopifnot(chr %in% colnames(myGWAS))
  stopifnot(pos %in% colnames(myGWAS))
}

print(flag)
# filter the required data
if(flag == 0){
  myGWAS <- myGWAS %>% select(c(all_of(rs_id), zscore, all_of(A1), all_of(A2)))
  names(myGWAS)[c(1, 2, 3, 4)] <- c("rs_id", "zscore", "A1", "A2")
}else{
  myGWAS <- myGWAS %>% select(c(all_of(rs_id), zscore, all_of(A1), all_of(A2), all_of(chr), all_of(pos)))
  names(myGWAS)[c(1, 2, 3, 4, 5, 6)] <- c("rs_id", "zscore", "A1", "A2", "chromosome", "position")
  load("reference_panel_1000G/variant_metadata.Rdata")
  print(colnames(df))
  # 合并两个数据框，根据chromosome列和position列匹配
#  df$chromosome <- as.numeric(as.character(df$chromosome))
#  df$position <- as.numeric(as.character(df$position))
  myGWAS$chromosome <- as.numeric(myGWAS$chromosome)
  myGWAS$position <- as.numeric(myGWAS$position)
  merged_data <- merge(myGWAS, df[, c("chromosome", "position", "id")], by = c("chromosome", "position"))
  print(head(merged_data, n=10))
  names(merged_data)[names(merged_data) == "rs_id"] <- "variant_id"
  names(merged_data)[names(merged_data) == "id"] <- "rs_id"
  myGWAS <- merged_data[,c("rs_id", "zscore", "A1", "A2")]
  print(head(myGWAS, n=10))
}

# Quality Control
# Remove summary statistics that do not have both p-values and beta
myGWAS <- filter(myGWAS, !is.na(zscore))

# Prepare input files
if(model == "mashr"){
  modelDB <- switch (tissue, Adipose_Subcutaneous = "./mashr/mashr_Adipose_Subcutaneous.db",
                   Adipose_Visceral_Omentum = "./mashr/mashr_Adipose_Visceral_Omentum.db",
                   Adrenal_Gland = "./mashr/mashr_Adrenal_Gland.db",
                   Artery_Aorta = "./mashr/mashr_Artery_Aorta.db",
                   Artery_Coronary = "./mashr/mashr_Artery_Coronary.db",
                   Artery_Tibial = "./mashr/mashr_Artery_Tibial.db",
                   Brain_Amygdala = "./mashr/mashr_Brain_Amygdala.db",
                   Brain_Anterior_cingulate_cortex_BA24 = "./mashr/mashr_Brain_Anterior_cingulate_cortex_BA24.db",
                   Brain_Caudate_basal_ganglia = "./mashr/mashr_Brain_Caudate_basal_ganglia.db",
                   Brain_Cerebellar_Hemisphere = "./mashr/mashr_Brain_Cerebellar_Hemisphere.db",
                   Brain_Cerebellum = "./mashr/mashr_Brain_Cerebellum.db",
                   Brain_Cortex = "./mashr/mashr_Brain_Cortex.db",
                   Brain_Hippocampus = "./mashr/mashr_Brain_Hippocampus.db",
                   Brain_Frontal_Cortex_BA9 = "./mashr/mashr_Brain_Frontal_Cortex_BA9.db",
                   Brain_Hypothalamus = "./mashr/mashr_Brain_Hypothalamus.db",
                   Brain_Nucleus_accumbens_basal_ganglia = "./mashr/mashr_Brain_Nucleus_accumbens_basal_ganglia.db",
                   Brain_Putamen_basal_ganglia = "./mashr/mashr_Brain_Putamen_basal_ganglia.db",
                   Brain_Spinal_cord_cervical_c_1 = "./mashr/mashr_mashr_Brain_Spinal_cord_cervical_c-1.db",
                   Brain_Substantia_nigra = "./mashr/mashr_Brain_Substantia_nigra.db",
                   Breast_Mammary = "./mashr/mashr_Breast_Mammary_Tissue.db",
                   Cells_Cultured_fibroblasts = "./mashr/mashr_Cells_Cultured_fibroblasts.db",
                   Cells_EBV_transformed_lymphocytes = "./mashr/mashr_Cells_EBV-transformed_lymphocytes.db",
                   Colon_Sigmoid = "./mashr/mashr_Colon_Sigmoid.db",
                   Colon_Transverse = "./mashr/mashr_Colon_Transverse.db",
                   Esophagus_Gastroesophageal_Junction = "./mashr/mashr_Esophagus_Gastroesophageal_Junction.db",
                   Esophagus_Mucosa = "./mashr/mashr_Esophagus_Mucosa.db",
                   Esophagus_Muscularis = "./mashr/mashr_Esophagus_Muscularis.db",
                   Heart_Atrial_Appendage = "./mashr/mashr_Heart_Atrial_Appendage.db",
                   Heart_Left_Ventricle = "./mashr/mashr_Heart_Left_Ventricle.db",
                   Kidney_Cortex = "./mashr/mashr_Kidney_Cortex.db",
                   Liver = "./mashr/mashr_Liver.db",
                   Lung = "./mashr/mashr_Lung.db",
                   Minor_Salivary_Gland = "./mashr/mashr_Minor_Salivary_Gland.db",
                   Muscle_Skeletal = "./mashr/mashr_Muscle_Skeletal.db",
                   Nerve_Tibial = "./mashr/mashr_Nerve_Tibial.db",
                   Ovary = "./mashr/mashr_Ovary.db",
                   Pancreas = "./mashr/mashr_Pancreas.db",
                   Pituitary = "./mashr/mashr_Pituitary.db",
                   Prostate = "./mashr/mashr_Prostate.db",
                   Skin_Not_Sun_Exposed_Suprapubic = "./mashr/mashr_Skin_Not_Sun_Exposed_Suprapubic.db",
                   Skin_Sun_Exposed_Lower_leg = "./mashr/mashr_Skin_Sun_Exposed_Lower_leg.db",
                   Small_Intestine_Terminal_Ileum = "./mashr/mashr_Small_Intestine_Terminal_Ileum.db",
                   Spleen = "./mashr/mashr_Spleen.db",
                   Stomach = "./mashr/mashr_Stomach.db",
                   Testis = "./mashr/mashr_Testis.db",
                   Thyroid = "./mashr/mashr_Thyroid.db",
                   Uterus = "./mashr/mashr_Uterus.db",
                   Vagina = "./mashr/mashr_Vagina.db",
                   Whole_Blood = "./mashr/mashr_Whole_Blood.db",
                   stop("Input Error!")
  )
  covariance <- switch (tissue,
                      Adipose_Subcutaneous = "./mashr/mashr_Adipose_Subcutaneous.txt.gz",
                      Adipose_Visceral_Omentum = "./mashr/mashr_Adipose_Visceral_Omentum.txt.gz",
                      Adrenal_Gland = "./mashr/mashr_Adrenal_Gland.txt.gz",
                      Artery_Aorta = "./mashr/mashr_Artery_Aorta.txt.gz",
                      Artery_Coronary = "./mashr/mashr_Artery_Coronary.txt.gz",
                      Artery_Tibial = "./mashr/mashr_Artery_Tibial.txt.gz",
                      Brain_Amygdala = "./mashr/mashr_Brain_Amygdala.txt.gz",
                      Brain_Anterior_cingulate_cortex_BA24 = "./mashr/mashr_Brain_Anterior_cingulate_cortex_BA24.txt.gz",
                      Brain_Caudate_basal_ganglia = "./mashr/mashr_Brain_Caudate_basal_ganglia.txt.gz",
                      Brain_Cerebellar_Hemisphere = "./mashr/mashr_Brain_Cerebellar_Hemisphere.txt.gz",
                      Brain_Cerebellum = "./mashr/mashr_Brain_Cerebellum.txt.gz",
                      Brain_Cortex = "./mashr/mashr_Brain_Cortex.txt.gz",
                      Brain_Hippocampus = "./mashr/mashr_Brain_Hippocampus.txt.gz",
                      Brain_Frontal_Cortex_BA9 = "./mashr/mashr_Brain_Frontal_Cortex_BA9.txt.gz",
                      Brain_Hypothalamus = "./mashr/mashr_Brain_Hypothalamus.txt.gz",
                      Brain_Nucleus_accumbens_basal_ganglia = "./mashr/mashr_Brain_Nucleus_accumbens_basal_ganglia.txt.gz",
                      Brain_Putamen_basal_ganglia = "./mashr/mashr_Brain_Putamen_basal_ganglia.txt.gz",
                      Brain_Spinal_cord_cervical_c_1 = "./mashr/mashr_mashr_Brain_Spinal_cord_cervical_c-1.txt.gz",
                      Brain_Substantia_nigra = "./mashr/mashr_Brain_Hippocampus.txt.gz",
                      Breast_Mammary = "./mashr/mashr_Breast_Mammary_Tissue.txt.gz",
                      Cells_Cultured_fibroblasts = "./mashr/mashr_Cells_Cultured_fibroblasts.txt.gz",
                      Cells_EBV_transformed_lymphocytes = "./mashr/mashr_Cells_EBV-transformed_lymphocytes.txt.gz",
                      Colon_Sigmoid = "./mashr/mashr_Colon_Sigmoid.txt.gz",
                      Colon_Transverse = "./mashr/mashr_Colon_Transverse.txt.gz",
                      Esophagus_Gastroesophageal_Junction = "./mashr/mashr_Esophagus_Gastroesophageal_Junction.txt.gz",
                      Esophagus_Mucosa = "./mashr/mashr_Esophagus_Mucosa.txt.gz",
                      Esophagus_Muscularis = "./mashr/mashr_Esophagus_Muscularis.txt.gz",
                      Heart_Atrial_Appendage = "./mashr/mashr_Heart_Atrial_Appendage.txt.gz",
                      Heart_Left_Ventricle = "./mashr/mashr_Heart_Left_Ventricle.txt.gz",
                      Kidney_Cortex = "./mashr/mashr_Kidney_Cortex.txt.gz",
                      Liver = "./mashr/mashr_Liver.txt.gz",
                      Lung = "./mashr/mashr_Lung.txt.gz",
                      Minor_Salivary_Gland = "./mashr/mashr_Minor_Salivary_Gland.txt.gz",
                      Muscle_Skeletal = "./mashr/mashr_Muscle_Skeletal.txt.gz",
                      Nerve_Tibial = "./mashr/mashr_Nerve_Tibial.txt.gz",
                      Ovary = "./mashr/mashr_Ovary.txt.gz",
                      Pancreas = "./mashr/mashr_Pancreas.txt.gz",
                      Pituitary = "./mashr/mashr_Pituitary.txt.gz",
                      Prostate = "./mashr/mashr_Prostate.txt.gz",
                      Skin_Not_Sun_Exposed_Suprapubic = "./mashr/mashr_Skin_Not_Sun_Exposed_Suprapubic.txt.gz",
                      Skin_Sun_Exposed_Lower_leg = "./mashr/mashr_Skin_Sun_Exposed_Lower_leg.txt.gz",
                      Small_Intestine_Terminal_Ileum = "./mashr/mashr_Small_Intestine_Terminal_Ileum.txt.gz",
                      Spleen = "./mashr/mashr_Spleen.txt.gz",
                      Stomach = "./mashr/mashr_Stomach.txt.gz",
                      Testis = "./mashr/mashr_Testis.txt.gz",
                      Thyroid = "./mashr/mashr_Thyroid.txt.gz",
                      Uterus = "./mashr/mashr_Uterus.txt.gz",
                      Vagina = "./mashr/mashr_Vagina.txt.gz",
                      Whole_Blood = "./mashr/mashr_Whole_Blood.txt.gz",
                      stop("Input Error!")
  )
}else{
  modelDB <- switch (tissue, Adipose_Subcutaneous = "./elastic_net_models/en_Adipose_Subcutaneous.db",
                   Adipose_Visceral_Omentum = "./elastic_net_models/en_Adipose_Visceral_Omentum.db",
                   Adrenal_Gland = "./elastic_net_models/en_Adrenal_Gland.db",
                   Artery_Aorta = "./elastic_net_models/en_Artery_Aorta.db",
                   Artery_Coronary = "./elastic_net_models/en_Artery_Coronary.db",
                   Artery_Tibial = "./elastic_net_models/en_Artery_Tibial.db",
                   Brain_Amygdala = "./elastic_net_models/en_Brain_Amygdala.db",
                   Brain_Anterior_cingulate_cortex_BA24 = "./elastic_net_models/en_Brain_Anterior_cingulate_cortex_BA24.db",
                   Brain_Caudate_basal_ganglia = "./elastic_net_models/en_Brain_Caudate_basal_ganglia.db",
                   Brain_Cerebellar_Hemisphere = "./elastic_net_models/en_Brain_Cerebellar_Hemisphere.db",
                   Brain_Cerebellum = "./elastic_net_models/en_Brain_Cerebellum.db",
                   Brain_Cortex = "./elastic_net_models/en_Brain_Cortex.db",
                   Brain_Hippocampus = "./elastic_net_models/en_Brain_Hippocampus.db",
                   Brain_Frontal_Cortex_BA9 = "./elastic_net_models/en_Brain_Frontal_Cortex_BA9.db",
                   Brain_Hypothalamus = "./elastic_net_models/en_Brain_Hypothalamus.db",
                   Brain_Nucleus_accumbens_basal_ganglia = "./elastic_net_models/en_Brain_Nucleus_accumbens_basal_ganglia.db",
                   Brain_Putamen_basal_ganglia = "./elastic_net_models/en_Brain_Putamen_basal_ganglia.db",
                   Brain_Spinal_cord_cervical_c_1 = "./elastic_net_models/en_mashr_Brain_Spinal_cord_cervical_c-1.db",
                   Brain_Substantia_nigra = "./elastic_net_models/en_Brain_Substantia_nigra.db",
                   Breast_Mammary = "./elastic_net_models/en_Breast_Mammary_Tissue.db",
                   Cells_Cultured_fibroblasts = "./elastic_net_models/en_Cells_Cultured_fibroblasts.db",
                   Cells_EBV_transformed_lymphocytes = "./elastic_net_models/en_Cells_EBV-transformed_lymphocytes.db",
                   Colon_Sigmoid = "./elastic_net_models/en_Colon_Sigmoid.db",
                   Colon_Transverse = "./elastic_net_models/en_Colon_Transverse.db",
                   Esophagus_Gastroesophageal_Junction = "./elastic_net_models/en_Esophagus_Gastroesophageal_Junction.db",
                   Esophagus_Mucosa = "./elastic_net_models/en_Esophagus_Mucosa.db",
                   Esophagus_Muscularis = "./elastic_net_models/en_Esophagus_Muscularis.db",
                   Heart_Atrial_Appendage = "./elastic_net_models/en_Heart_Atrial_Appendage.db",
                   Heart_Left_Ventricle = "./elastic_net_models/en_Heart_Left_Ventricle.db",
                   Kidney_Cortex = "./elastic_net_models/en_Kidney_Cortex.db",
                   Liver = "./elastic_net_models/en_Liver.db",
                   Lung = "./elastic_net_models/en_Lung.db",
                   Minor_Salivary_Gland = "./elastic_net_models/en_Minor_Salivary_Gland.db",
                   Muscle_Skeletal = "./elastic_net_models/en_Muscle_Skeletal.db",
                   Nerve_Tibial = "./elastic_net_models/en_Nerve_Tibial.db",
                   Ovary = "./elastic_net_models/en_Ovary.db",
                   Pancreas = "./elastic_net_models/en_Pancreas.db",
                   Pituitary = "./elastic_net_models/en_Pituitary.db",
                   Prostate = "./elastic_net_models/en_Prostate.db",
                   Skin_Not_Sun_Exposed_Suprapubic = "./elastic_net_models/en_Skin_Not_Sun_Exposed_Suprapubic.db",
                   Skin_Sun_Exposed_Lower_leg = "./elastic_net_models/en_Skin_Sun_Exposed_Lower_leg.db",
                   Small_Intestine_Terminal_Ileum = "./elastic_net_models/en_Small_Intestine_Terminal_Ileum.db",
                   Spleen = "./elastic_net_models/en_Spleen.db",
                   Stomach = "./elastic_net_models/en_Stomach.db",
                   Testis = "./elastic_net_models/en_Testis.db",
                   Thyroid = "./elastic_net_models/en_Thyroid.db",
                   Uterus = "./elastic_net_models/en_Uterus.db",
                   Vagina = "./elastic_net_models/en_Vagina.db",
                   Whole_Blood = "./elastic_net_models/en_Whole_Blood.db",
                   stop("Input Error!")
  )

  covariance <- switch (tissue,
                      Adipose_Subcutaneous = "./elastic_net_models/en_Adipose_Subcutaneous.txt.gz",
                      Adipose_Visceral_Omentum = "./elastic_net_models/en_Adipose_Visceral_Omentum.txt.gz",
                      Adrenal_Gland = "./elastic_net_models/en_Adrenal_Gland.txt.gz",
                      Artery_Aorta = "./elastic_net_models/en_Artery_Aorta.txt.gz",
                      Artery_Coronary = "./elastic_net_models/en_Artery_Coronary.txt.gz",
                      Artery_Tibial = "./elastic_net_models/en_Artery_Tibial.txt.gz",
                      Brain_Amygdala = "./elastic_net_models/en_Brain_Amygdala.txt.gz",
                      Brain_Anterior_cingulate_cortex_BA24 = "./elastic_net_models/en_Brain_Anterior_cingulate_cortex_BA24.txt.gz",
                      Brain_Caudate_basal_ganglia = "./elastic_net_models/en_Brain_Caudate_basal_ganglia.txt.gz",
                      Brain_Cerebellar_Hemisphere = "./elastic_net_models/en_Brain_Cerebellar_Hemisphere.txt.gz",
                      Brain_Cerebellum = "./elastic_net_models/en_Brain_Cerebellum.txt.gz",
                      Brain_Cortex = "./elastic_net_models/en_Brain_Cortex.txt.gz",
                      Brain_Hippocampus = "./elastic_net_models/en_Brain_Hippocampus.txt.gz",
                      Brain_Frontal_Cortex_BA9 = "./elastic_net_models/en_Brain_Frontal_Cortex_BA9.txt.gz",
                      Brain_Hypothalamus = "./elastic_net_models/en_Brain_Hypothalamus.txt.gz",
                      Brain_Nucleus_accumbens_basal_ganglia = "./elastic_net_models/en_Brain_Nucleus_accumbens_basal_ganglia.txt.gz",
                      Brain_Putamen_basal_ganglia = "./elastic_net_models/en_Brain_Putamen_basal_ganglia.txt.gz",
                      Brain_Spinal_cord_cervical_c_1 = "./elastic_net_models/en_mashr_Brain_Spinal_cord_cervical_c-1.txt.gz",
                      Brain_Substantia_nigra = "./elastic_net_models/en_Brain_Hippocampus.txt.gz",
                      Breast_Mammary = "./elastic_net_models/en_Breast_Mammary_Tissue.txt.gz",
                      Cells_Cultured_fibroblasts = "./elastic_net_models/en_Cells_Cultured_fibroblasts.txt.gz",
                      Cells_EBV_transformed_lymphocytes = "./elastic_net_models/en_Cells_EBV-transformed_lymphocytes.txt.gz",
                      Colon_Sigmoid = "./elastic_net_models/en_Colon_Sigmoid.txt.gz",
                      Colon_Transverse = "./elastic_net_models/en_Colon_Transverse.txt.gz",
                      Esophagus_Gastroesophageal_Junction = "./elastic_net_models/en_Esophagus_Gastroesophageal_Junction.txt.gz",
                      Esophagus_Mucosa = "./elastic_net_models/en_Esophagus_Mucosa.txt.gz",
                      Esophagus_Muscularis = "./elastic_net_models/en_Esophagus_Muscularis.txt.gz",
                      Heart_Atrial_Appendage = "./elastic_net_models/en_Heart_Atrial_Appendage.txt.gz",
                      Heart_Left_Ventricle = "./elastic_net_models/en_Heart_Left_Ventricle.txt.gz",
                      Kidney_Cortex = "./elastic_net_models/en_Kidney_Cortex.txt.gz",
                      Liver = "./elastic_net_models/en_Liver.txt.gz",
                      Lung = "./elastic_net_models/en_Lung.txt.gz",
                      Minor_Salivary_Gland = "./elastic_net_models/en_Minor_Salivary_Gland.txt.gz",
                      Muscle_Skeletal = "./elastic_net_models/en_Muscle_Skeletal.txt.gz",
                      Nerve_Tibial = "./elastic_net_models/en_Nerve_Tibial.txt.gz",
                      Ovary = "./elastic_net_models/en_Ovary.txt.gz",
                      Pancreas = "./elastic_net_models/en_Pancreas.txt.gz",
                      Pituitary = "./elastic_net_models/en_Pituitary.txt.gz",
                      Prostate = "./elastic_net_models/en_Prostate.txt.gz",
                      Skin_Not_Sun_Exposed_Suprapubic = "./elastic_net_models/en_Skin_Not_Sun_Exposed_Suprapubic.txt.gz",
                      Skin_Sun_Exposed_Lower_leg = "./elastic_net_models/en_Skin_Sun_Exposed_Lower_leg.txt.gz",
                      Small_Intestine_Terminal_Ileum = "./elastic_net_models/en_Small_Intestine_Terminal_Ileum.txt.gz",
                      Spleen = "./elastic_net_models/en_Spleen.txt.gz",
                      Stomach = "./elastic_net_models/en_Stomach.txt.gz",
                      Testis = "./elastic_net_models/en_Testis.txt.gz",
                      Thyroid = "./elastic_net_models/en_Thyroid.txt.gz",
                      Uterus = "./elastic_net_models/en_Uterus.txt.gz",
                      Vagina = "./elastic_net_models/en_Vagina.txt.gz",
                      Whole_Blood = "./elastic_net_models/en_Whole_Blood.txt.gz",
                      stop("Input Error!")
  )
}

dir_input <- paste0("dir_input_", job_id)
dir_run <- paste0("dir_SPrediXcan_", job_id)
dir_create <-  dir.create(file.path(getwd(), dir_run), showWarnings = FALSE,
                          recursive = TRUE)
dir_create <-  dir.create(file.path(getwd(), dir_input), showWarnings = FALSE,
                          recursive = TRUE)

write.table(myGWAS[,1:4], file.path(dir_input, "assoc.gwas.txt"),
            sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)


# compress the file
compress_run <- try({
  system(paste0("gzip -f ./", dir_input, "/assoc.gwas.txt"))
})
compressStatus <- ifelse(compress_run == 0, TRUE, FALSE)
stopifnot(compressStatus != 0)

# Run the method
 if(model == "mashr"){
  tool_input <- paste0("--model_db_path ", modelDB, " --covariance ", covariance,
                     " --gwas_file ", file.path(dir_input, "assoc.gwas.txt.gz"),
                     " --snp_column rs_id --effect_allele_column A1 --keep_non_rsid ",
                     "--non_effect_allele_column A2 --zscore_column zscore",
                     " --model_db_snp_key varid --throw --output_file ", file.path(dir_run, "result.csv"))
}else{
  tool_input <- paste0("--model_db_path ", modelDB, " --covariance ", covariance,
                     " --gwas_file ", file.path(dir_input, "assoc.gwas.txt.gz"),
                     " --snp_column rs_id --effect_allele_column A1 ",
                     "--non_effect_allele_column A2 --zscore_column zscore --output_file ",
                     file.path(dir_run, "result.csv"))
}

cmd <- paste("python SPrediXcan.py", tool_input)
print(cmd)

ret_run <- try({
  system(cmd, input = tool_input)
})
ret_status <- ifelse(ret_run == 0, TRUE, FALSE)
if(ret_status){
  if(!file.exists(file.path(dir_run,"result.csv"))){
    ret_status <- FALSE
  }
}
stopifnot(ret_status != 0)

res <- read.csv(file.path(dir_run,"result.csv"))
stopifnot(!all(is.na(res$pvalue)))
if(model == "enet"){
  res <- res[, c("gene", "gene_name", "zscore", "pvalue", "pred_perf_r2", "pred_perf_pval")]
}else{
  res <- res[, c("gene", "gene_name", "zscore", "pvalue")]
}

file.remove(file.path(dir_run,"result.csv"))
write.table(res, file.path(dir_run,"result.out"),
            sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)

img <- ggplot(res, aes(x = gene_name, y = -log10(pvalue))) +
              geom_point(aes(color = -log10(pvalue)), size =1) +
#              scale_color_identity() +
              scale_color_gradient(low = "skyblue", high = "purple") +
              labs(title = "Visualisation of results",
                   x = "gene",
                   y = "-log10(pvalue)") + 
              theme(panel.background = element_rect(fill = "white"), panel.grid.major = element_blank(), panel.grid.minor = element_blank())  +
              scale_x_discrete(labels=NULL)
  
ggsave(file.path(dir_run, "img.png"), img, width = 10, height = 6, dpi = 300)

img2 <- ggplot(res, aes(x = gene_name, y = zscore)) +
              geom_point(aes(color = zscore), size =1) +
#              scale_color_identity() +
              scale_color_gradient(low = "skyblue", high = "purple") +
              labs(title = "Visualisation of results",
                   x = "gene",
                   y = "zscore") + 
              theme(panel.background = element_rect(fill = "white"), panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
              scale_x_discrete(labels=NULL)
  
ggsave(file.path(dir_run, "img2.png"), img2, width = 10, height = 6, dpi = 300)