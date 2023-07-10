library('optparse')
library(dplyr)
if (!requireNamespace("readr", quietly = TRUE))
  install.packages("readr")
library(readr)
if (!requireNamespace("magrittr", quietly = TRUE))
  install.packages("magrittr")
library(magrittr)
library(ggplot2)

option_list<- list(
  make_option(c("-g", "--gwas"), type = "character",  default = NULL,
              help = "specify the prepared GWAS file [default \"%default\"]"),
  make_option(c("-e","--eQTL"), type = "character", default = NULL,
              help = "specify the prepared eQTL annotation file [default \"%default\"]"),
  make_option(c("-t", "--tissue"), type = "character",  default = "Whole_Blood",
              help = "specify the tissue name [default \"%default\"]"),
  make_option("--prefix", type = "character", default = "prefix",
              help = "specify the prefix for the output files [default \"%default\"]"),
  make_option("--zscore", type = "character", default = NULL,
              help = "The zscore column of GWAS input file [default \"%default\"]"),
  make_option("--rsID", type = "character", default = NULL,
              help = "The rs_id column of GWAS input file [default \"%default\"]"),
  make_option("--locID", type = "character", default = NULL,
              help = "The loc_id column of GWAS input file [default \"%default\"]"),
  make_option("--variantID", type = "character", default = NULL,
              help = "The variant_id column of GWAS input file [default \"%default\"]"),
  make_option("--GRCP", type = "numeric", default = 0.5,
              help = "Threshold of GRCP [default \"%default\"]"),
  make_option("--GLCP", type = "numeric", default = 0.5,
              help = "Threshold of GLCP [default \"%default\"]"),
  make_option("--RCP", type = "numeric", default = 0.5,
              help = "Threshold of RCP [default \"%default\"]"),
  make_option("--jobID", type = "character", default = NULL,
              help = "job id [default \"%default\"]"),
  make_option("--flag", type = "integer", default = NULL,
              help = "1 indicates Multi-tissue eQTL annotation with hg38 position ID;
              2 indicates Multi-tissue eQTL annotation with rs ID;
              0 indicates using your own eQTL annotation")
)

opt_parser <- OptionParser(option_list=option_list) #解析参数
opt_parser <- add_option(opt_parser, "--ngwas", type = "integer", default = 0, help = "number of gwas data")
opt_parser <- add_option(opt_parser, "--ng", dest = "ngwas")

opt <- parse_args(opt_parser) #解析参数
gp <- opt$gwas
ep <- opt$eQTL
tissue <- opt$tissue
rs_id <- opt$rsID
prefix <- opt$prefix
zscore <- opt$zscore
flag <- as.numeric(opt$flag)
loc_id <- opt$locID
variant_id <- opt$variantID
n_gwas <- as.numeric(opt$ngwas)
grcp <- as.numeric(opt$GRCP)
glcp <- as.numeric(opt$GLCP)
rcp <- as.numeric(opt$RCP)
job_id <- opt$jobID

stopifnot(file.exists(gp))
stopifnot(flag == 1 | flag == 2 | flag ==0)
if(flag == 0){
  stopifnot(file.exists(ep))
}

# read the file
myGWAS <- read.table(file = gp, header = T)

stopifnot(ncol(myGWAS) >= 3)
if(flag == 1 | flag == 0){
  stopifnot(variant_id %in% colnames(myGWAS))
}else if(flag == 2 ){
  stopifnot(rs_id %in% colnames(myGWAS))
}
stopifnot(zscore %in% colnames(myGWAS))
stopifnot(loc_id %in% colnames(myGWAS))

# Filter the required data
if(flag == 1){
  myGWAS <- myGWAS %>% select(c(variant_id, loc_id, zscore))
  names(myGWAS)[c(1, 2, 3)] <- c("variant_id","loc_id", "zscore")
}else if(flag == 2){
  myGWAS <- myGWAS %>% select(c(rs_id, loc_id, zscore))
  names(myGWAS)[c(1, 2, 3)] <- c("rs_id", "loc_id", "zscore")
}else if(flag == 0){
  myGWAS <- myGWAS %>% select(c(variant_id, loc_id, zscore))
  names(myGWAS)[c(1, 2, 3)] <- c("variant_id","loc_id", "zscore")
  myeQTL <- read.table(ep, header = T)
}

# Quality Control
myGWAS <- filter(myGWAS, !is.na(zscore))

dir_input <- paste0("dir_input_", job_id)
dir_run <- paste0("dir_fastenloc_", job_id)
dir_create <-  dir.create(file.path(getwd(), dir_run), showWarnings = FALSE,
                          recursive = TRUE)
dir_create <-  dir.create(file.path(getwd(), dir_input), showWarnings = FALSE,
                          recursive = TRUE)

# Preprocess the GWAS input file
write_delim(myGWAS[,1:3], file.path(dir_input, "gwas.zval.gz"),
            delim = " ", col_names = FALSE)
if(flag ==0){
  write_delim(myeQTL, file.path(dir_input, "eQTL.vcf.gz"),
            delim = " ", col_names = FALSE)
}
torusInput <- paste0("-d ", file.path(dir_input, "gwas.zval.gz"),
                     " --load_zval -dump_pip ",file.path(dir_input, "gwas.pip"))
torusCMD <- paste0("./torus/src/torus ", torusInput)

# to convert the z-scores to PIPs
torus_run <- try({
  system(torusCMD, input = torusCMD)
})
torusStatus <- ifelse(torus_run == 0, TRUE, FALSE)
stopifnot(torusStatus != 0)

# compress the file
compress_run <- try({
  system(paste0("gzip -f ./", file.path(dir_input, "gwas.pip")))
})
compressStatus <- ifelse(compress_run == 0, TRUE, FALSE)
stopifnot(compressStatus != 0)

# Run the method
if(flag == 1){
  tool_input <- paste0("-eqtl ./dir_eqtl/gtex_v8.eqtl_annot.vcf.gz -gwas ",
                       file.path(dir_input, "gwas.pip.gz"), " -prefix ", prefix,
                       " -tissue ",tissue)
}else if(flag == 2){
  tool_input <- paste0("-eqtl ./dir_eqtl/gtex_v8.eqtl_annot_rsid.vcf.gz -gwas ",
                       file.path(dir_input, "gwas.pip.gz"), " -prefix ", prefix,
                       " -tissue ",tissue)
}else if(flag == 0){
  tool_input <- paste0("-eqtl ", file.path(dir_input, "eQTL.vcf.gz"), " -gwas ",
                       file.path(dir_input, "gwas.pip.gz"), " -prefix ", prefix)
  if(!is.null(tissue)){
    tool_input <- paste0(tool_input, " -tissue ", tissue)
  }
}
if(n_gwas != 0){
  tool_input <- paste0(tool_input, " -total_variants ", n_gwas)
}

cmd <- paste("./fastenloc", tool_input)
print(cmd)

ret_run <- try({
  system(cmd, input = tool_input)
})

# Judge if there is an error in executing the commmand
ret_status <- ifelse(ret_run == 0, TRUE, FALSE)
if(ret_status){
  if(!all(file.exists(paste0(prefix, ".enloc.sig.out"), paste0(prefix, ".enloc.snp.out"),
                      paste0(prefix, ".enloc.gene.out"), paste0(prefix, ".enloc.enrich.out")))){
    ret_status <- FALSE
  }
}
stopifnot(ret_status != 0)

# process the output
file.copy(paste0(prefix, ".enloc.enrich.out"), dir_run)
file.copy(paste0(prefix, ".enloc.sig.out"), dir_run)
file.copy(paste0(prefix, ".enloc.snp.out"), dir_run)
file.copy(paste0(prefix, ".enloc.gene.out"), dir_run)

sig <- read.table(file.path(dir_run, paste0(prefix, ".enloc.sig.out")), header = T, stringsAsFactors = FALSE)
gene <- read.table(file.path(dir_run, paste0(prefix, ".enloc.gene.out")), header = T, stringsAsFactors = FALSE)
names(sig) <- c("Signal", "Num_SNP", "CPIP_qtl", "CPIP_gwas_marginal", "CPIP_gwas_qtl_prior",
                "RCP", "LCP")
names(gene) <- c("Gene", "GRCP", "GLCP")

# Filtering by threshold
# filtered_sig <- sig[as.numeric(format(RCP, scientific = FALSE)) > rcp,]
filtered_sig <- sig[sig$RCP > rcp,]

# Filtering by threshold
# filtered_gene <- gene[(as.numeric(format(GRCP, scientific = FALSE)) > grcp) & (as.numeric(format(GLCP, scientific = FALSE)) > glcp),]
filtered_gene <- gene[gene$GRCP > grcp & gene$GLCP > glcp,]

write.table(filtered_sig, file.path(dir_run, paste0(prefix, ".enloc.sig.extract.out")),
            sep = " ", row.names = FALSE, col.names = T, quote = FALSE)
write.table(filtered_gene, file.path(dir_run, paste0(prefix, ".enloc.gene.extract.out")),
            sep = " ", row.names = FALSE, col.names = T, quote = FALSE)

img <-  ggplot(data = sig, aes(x = LCP, y = RCP)) +
               geom_point(aes(color = ifelse(Signal %in% filtered_sig$Signal, "red", "skyblue")), size = 1) +
               scale_color_identity() +
#               geom_jitter(width = 0.1, height = 0.1, size = 2)+
               labs(title = "Visualisation of Signal-level colocalization result",
                    x = "Locus-level colocalization probability",
                    y = "Regional colocalization probability")+ 
               labs(x = NULL, y = NULL) +
               theme(panel.grid =element_blank(), axis.line = element_blank(),
                      panel.background = element_rect(fill = "white"))
#                     axis.text.x = element_blank(),
#                     axis.text.y = element_blank(),
#                     axis.ticks = element_blank())
#                     axis.title.x = element_blank(),
#                     axis.title.y = element_blank())
#               scale_y_log10()
               
ggsave(file.path(dir_run, "img1.png"), img, width = 20, height = 20, dpi = 300)

img2 <-  ggplot(data = gene, aes(x = GLCP, y = GRCP)) +
               geom_point(aes(color = ifelse(Gene %in% filtered_gene$Gene, "red", "skyblue")), size =1) +
               scale_color_identity() +
               labs(title = "Visualisation of Gene-level colocalization result",
                    x = "Gene locus-level colocalization probability",
                    y = "Gene variant-level colocalization probability")+ 
               labs(x = NULL, y = NULL) +
               theme(panel.grid =element_blank(),
                     panel.background = element_rect(fill = "white"))
#                     axis.text.x = element_blank(),
#                     axis.text.y = element_blank(),
#                     axis.ticks = element_blank())
#                     axis.title.x = element_blank(),
#                     axis.title.y = element_blank())
#               scale_y_log10()
               
ggsave(file.path(dir_run, "img2.png"), img2, width = 20, height = 20, dpi = 300)