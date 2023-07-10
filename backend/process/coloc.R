library(remotes)
# install_github("chr1swallace/coloc",build_vignettes=FALSE)
library("coloc")
library(dplyr)
library('optparse')
library(ggplot2)

option_list<- list(
  make_option(c("-g","--gwas"),  type = "character",  default = FALSE,  
              help = "GWAS Input File "),
  make_option(c("-e","--eQTL"), type = "character", default = FALSE, 
              help = "eQTL Input File"),
  make_option("--rsID", type = "character", default = "rs_id",
              help = "The rs_id column of GWAS input file [default \"%default\"]"),
  make_option("--pval", type = "character", default = "pval",
              help = "The pvalue column of GWAS input file [default \"%default\"]"),
  make_option("--beta", type = "character", default = "beta",
              help = "The beta column of GWAS input file [default \"%default\"]"),
  make_option("--varbeta", type = "character", default = "varbeta",
              help = "The varbeta column of GWAS input file [default \"%default\"]"),
  make_option("--ersID", type = "character", default = "rs_id",
              help = "The rs_id column of eQTL input file [default \"%default\"]"),
  make_option("--epval", type = "character", default = "pval",
              help = "The pvalue column of eQTL input file [default \"%default\"]"),
  make_option("--emaf", type = "character", default = "maf",
              help = "The minor allele frequency column of eQTL input file [default \"%default\"]"),
  make_option("--geneID", type = "character", default = "gene_name",
              help = "The gene id column of eQTL input file [default \"%default\"]"),
  make_option("--threshold", type = "numeric", default = 0.95,
              help = "Posterior probabilities of H4 above this threshold were considered colocalization signals. [default \"%default\"]"),
  make_option("--flag", type = "integer", default = 0,
              help = "1 indicates using GTex v8 eQTL data;
              0 indicates using your own eQTL data"),
  make_option(c("-t", "--tissue"), type = "character",  default = "Whole_Blood",
              help = "specify the tissue name [default \"%default\"]"),
  make_option("--jobID", type = "character", default = NULL,
              help = "job id[default \"%default\"]")
)
opt_parser <- OptionParser(option_list=option_list) #解析参数
opt_parser <- add_option(opt_parser, "--ngwas", type = "integer", default = NULL, help = "number of gwas data")
opt_parser <- add_option(opt_parser, "--ng", dest = "ngwas")
opt_parser <- add_option(opt_parser, "--neqtl", type = "integer", default = NULL, help = "number of eQTL data")
opt_parser <- add_option(opt_parser, "--ne", dest = "neqtl")

opt <- parse_args(opt_parser) #解析参数
gp  <- opt$gwas
ep <- opt$eQTL
n_gwas <- as.numeric(opt$ngwas)
n_eQTL <- as.numeric(opt$neqtl)
rs_id <- opt$rsID
pval <- opt$pval
beta <- opt$beta
varbeta <- opt$varbeta
ers_id <- opt$ersID
epval <- opt$epval
emaf <- opt$emaf
gene_id <- opt$geneID
threshold <- as.numeric(opt$threshold)
flag <- as.numeric(opt$flag)
tissue <- opt$tissue
job_id <- opt$jobID
stopifnot(!is.null(n_gwas))
if(flag == 0){
  stopifnot(!is.null(n_eQTL))
}else{
  n_eQTL <- 15201
}

# read the file
gwas <- read.table(file=gp, header=T)
if(flag == 0){
  eqtl <- read.table(file=ep, header=T)
}else{
  ep <- switch(tissue, Adipose_Subcutaneous = "../GTEx_Analysis_v8_eQTL/Adipose_Subcutaneous.v8.egenes.txt.gz",
                 Adipose_visceral_Omentum = "../GTEx_Analysis_v8_eQTL/Adipose_Visceral_Omentum.v8.egenes.txt.gz",
                 Adrenal_Gland = "../GTEx_Analysis_v8_eQTL/Adrenal_Gland.v8.egenes.txt.gz",
                 Artery_Aorta = "../GTEx_Analysis_v8_eQTL/Artery_Aorta.v8.egenes.txt.gz",
                 Artery_Coronary = "../GTEx_Analysis_v8_eQTL/Artery_Coronary.v8.egenes.txt.gz",
                 Artery_Tibial = "../GTEx_Analysis_v8_eQTL/Artery_Tibial.v8.egenes.txt.gz",
                 Brain_Amygdala = "../GTEx_Analysis_v8_eQTL/Brain_Amygdala.v8.egenes.txt.gz",
                 Brain_Anterior_cingulate_cortex_BA24 = "../GTEx_Analysis_v8_eQTL/Brain_Anterior_cingulate_cortex_BA24.v8.egenes.txt.gz",
                 Brain_Caudate_basal_ganglia = "../GTEx_Analysis_v8_eQTL/Brain_Caudate_basal_ganglia.v8.egenes.txt.gz",
                 Brain_Cerebellar_Hemisphere = "../GTEx_Analysis_v8_eQTL/Brain_Cerebellar_Hemisphere.v8.egenes.txt.gz",
                 Brain_Cerebellum = "../GTEx_Analysis_v8_eQTL/Brain_Cerebellum.v8.egenes.txt.gz",
                 Brain_Cortex = "../GTEx_Analysis_v8_eQTL/Brain_Cortex.v8.egenes.txt.gz",
                 Brain_Frontal_Cortex_BA9 = "../GTEx_Analysis_v8_eQTL/Brain_Frontal_Cortex_BA9.v8.egenes.txt.gz",
                 Brain_Hippocampus = "../GTEx_Analysis_v8_eQTL/Brain_Hippocampus.v8.egenes.txt.gz",
                 Brain_Hypothalamus = "../GTEx_Analysis_v8_eQTL/Brain_Hypothalamus.v8.egenes.txt.gz",
                 Brain_Nucleus_accumbens_basal_ganglia = "../GTEx_Analysis_v8_eQTL/Brain_Nucleus_accumbens_basal_ganglia.v8.egenes.txt.gz",
                 Brain_Putamen_basal_ganglia = "../GTEx_Analysis_v8_eQTL/Brain_Putamen_basal_ganglia.v8.egenes.txt.gz",
                 Brain_Spinal_cord_cervical_c_1 = "../GTEx_Analysis_v8_eQTL/Brain_Spinal_cord_cervical_c-1.v8.egenes.txt.gz",
                 Brain_Substantia_nigra = "../GTEx_Analysis_v8_eQTL/Brain_Substantia_nigra.v8.egenes.txt.gz",
                 Breast_Mammary_Tissue = "../GTEx_Analysis_v8_eQTL/Breast_Mammary_Tissue.v8.egenes.txt.gz",
                 Cells_Cultured_fibroblasts = "../GTEx_Analysis_v8_eQTL/Cells_Cultured_fibroblasts.v8.egenes.txt.gz",
                 Cells_EBV_transformed_lymphocytes = "../GTEx_Analysis_v8_eQTL/Cells_EBV-transformed_lymphocytes.v8.egenes.txt.gz",
                 Colon_Sigmoid = "../GTEx_Analysis_v8_eQTL/Colon_Sigmoid.v8.egenes.txt.gz",
                 Colon_Transverse = "../GTEx_Analysis_v8_eQTL/Colon_Transverse.v8.egenes.txt.gz",
                 Esophagus_Gastroesophageal_Junction = "../GTEx_Analysis_v8_eQTL/Esophagus_Gastroesophageal_Junction.v8.egenes.txt.gz",
                 Esophagus_Mucosa = "../GTEx_Analysis_v8_eQTL/Esophagus_Mucosa.v8.egenes.txt.gz",
                 Esophagus_Muscularis = "../GTEx_Analysis_v8_eQTL/Esophagus_Muscularis.v8.egenes.txt.gz",
                 Heart_Atrial_Appendage = "../GTEx_Analysis_v8_eQTL/Heart_Atrial_Appendage.v8.egenes.txt.gz",
                 Heart_Left_Ventricle = "../GTEx_Analysis_v8_eQTL/Heart_Left_Ventricle.v8.egenes.txt.gz",
                 Kidney_Cortex = "../GTEx_Analysis_v8_eQTL/Kidney_Cortex.v8.egenes.txt.gz",
                 Liver = "../GTEx_Analysis_v8_eQTL/Liver.v8.egenes.txt.gz",
                 Lung = "../GTEx_Analysis_v8_eQTL/Lung.v8.egenes.txt.gz",
                 Minor_Salivary_Gland = "../GTEx_Analysis_v8_eQTL/Minor_Salivary_Gland.v8.egenes.txt.gz",
                 Muscle_Skeletal = "../GTEx_Analysis_v8_eQTL/Muscle_Skeletal.v8.egenes.txt.gz",
                 Nerve_Tibial = "../GTEx_Analysis_v8_eQTL/Nerve_Tibial.v8.egenes.txt.gz",
                 Ovary = "../GTEx_Analysis_v8_eQTL/Ovary.v8.egenes.txt.gz",
                 Pancreas = "../GTEx_Analysis_v8_eQTL/Pancreas.v8.egenes.txt.gz",
                 Pituitary = "../GTEx_Analysis_v8_eQTL/Pituitary.v8.egenes.txt.gz",
                 Prostate = "../GTEx_Analysis_v8_eQTL/Prostate.v8.egenes.txt.gz",
                 Skin_Not_Sun_Exposed_Suprapubic = "../GTEx_Analysis_v8_eQTL/Skin_Not_Sun_Exposed_Suprapubic.v8.egenes.txt.gz",
                 Skin_Sun_Exposed_Lower_leg = "../GTEx_Analysis_v8_eQTL/Skin_Sun_Exposed_Lower_leg.v8.egenes.txt.gz",
                 Small_Intestine_Terminal_Ileum = "../GTEx_Analysis_v8_eQTL/Small_Intestine_Terminal_Ileum.v8.egenes.txt.gz",
                 Spleen = "../GTEx_Analysis_v8_eQTL/Spleen.v8.egenes.txt.gz",
                 Stomach = "../GTEx_Analysis_v8_eQTL/Stomach.v8.egenes.txt.gz",
                 Testis = "../GTEx_Analysis_v8_eQTL/Testis.v8.egenes.txt.gz",
                 Thyroid = "../GTEx_Analysis_v8_eQTL/Thyroid.v8.egenes.txt.gz",
                 Uterus = "../GTEx_Analysis_v8_eQTL/Uterus.v8.egenes.txt.gz",
                 Vagina = "../GTEx_Analysis_v8_eQTL/Vagina.v8.egenes.txt.gz",
                 Whole_Blood = "../GTEx_Analysis_v8_eQTL/Whole_Blood.v8.egenes.txt.gz",
                 "Input Error!")
  eqtl <- read.table(file=ep, header=T)
}

stopifnot(ncol(gwas) >= 4)
stopifnot(rs_id %in% colnames(gwas))
stopifnot(pval %in% colnames(gwas))
stopifnot(beta %in% colnames(gwas))
stopifnot(varbeta %in% colnames(gwas))
gwas <- gwas %>% select(c(rs_id, pval, beta, varbeta))
names(gwas)[c(1, 2, 3, 4)] <- c("rs_id", "pval", "beta", "varbeta")

stopifnot(ncol(eqtl) >= 4)
stopifnot(ers_id %in% colnames(eqtl))
stopifnot(epval %in% colnames(eqtl))
stopifnot(emaf %in% colnames(eqtl))
stopifnot(gene_id %in% colnames(eqtl))
eqtl <- eqtl %>% select(c(ers_id, epval, emaf, gene_id))
names(eqtl)[c(1, 2, 3, 4)] <- c("rs_id", "pval", "MAF", "gene")

# Quality Control
gwas <- filter(gwas, !is.na(pval))
eqtl <- filter(eqtl, !is.na(pval))
eqtl <- filter(eqtl, !is.na(MAF))

dir_run <- paste0("dir_coloc_", job_id)
dir_create <-  dir.create(file.path(getwd(), dir_run), showWarnings = FALSE,
                          recursive = TRUE)

# Prepare the input
input <- merge(eqtl, gwas, by="rs_id", all=FALSE, suffixes=c("_eqtl","_gwas"))

# type="cc" 表示二元性状
# type="quant" 表示连续性状

result <- coloc.abf(dataset1=list(pvalues=input$pval_gwas, type="cc", s=0.33, N=n_gwas, snp=as.character(input$rs_id)), 
                    dataset2=list(pvalues=input$pval_eqtl, type="quant", N=n_eQTL, snp=as.character(input$rs_id)), MAF=input$MAF)

# df <- data.frame(t(unlist(result))) # 将列表转换为数据框
res <- result$results
merged_data <- merge(res, eqtl, by.x="snp", by.y="rs_id", all.x=TRUE)
print(colnames(merged_data))
res <- merged_data[,c("snp","gene","pvalues.df1", "pvalues.df2", "SNP.PP.H4")]
write.table(res, file = file.path(dir_run, "result.txt"), sep = "\t", row.names = F, col.names = T, quote = F) # 将数据框保存到文件中

# process the output
need_result = res %>% filter(SNP.PP.H4 > threshold)
need_result <- as.data.frame(need_result)
write.table(need_result, file.path(dir_run, "need_result.txt"),
            sep = " ",row.names = F, col.names = T, quote = FALSE)

names(result$results)[ncol(result$results)] <- "H4"
print(class(result$results$H4))

img <- ggplot(data = result$results, aes(x = snp, y = H4)) +
              geom_point(aes(color = ifelse(H4 > threshold, "red", "skyblue")), size =1) +
              scale_color_identity() +
              labs(title = "Visualisation of results",
                   x = "SNP",
                   y = "Posterior Probability of One Common Causal Variant")+ 
              theme(plot.background = element_rect(fill = "white"))+
              scale_x_discrete(labels=NULL)+
              scale_y_log10()+
              geom_hline(yintercept = threshold, color = "purple", linetype = "dashed")

ggsave(file.path(dir_run, "img.png"), img, width = 10, height = 6, dpi = 300)