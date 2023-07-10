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
              help = "the GWAS zscore and rsID files [default \"%default\"]"),
  make_option("--ld", type = "character", default = NULL,
              help = "the GWAS ld input file [default \"%default\"]"),
   make_option(c("-c", "--maxCasual"), type = "integer", default = 1,
              help = "the maximal number of causal variants [default \"%default\"]"),
  make_option(c("-e","--eQTL"), type = "character", default = NULL,
              help = "the eQTL zscore and rsID files [default \"%default\"]"),
  make_option("--eQTLld", type = "character", default = NULL,
              help = "the eQTL ld input file [default \"%default\"]"),
  make_option("--zscore", type = "character", default = NULL,
              help = "The zscore column of GWAS input file [default \"%default\"]"),
  make_option("--rsID", type = "character", default = NULL,
              help = "The rs_id column of GWAS input file [default \"%default\"]"),
  make_option("--ezscore", type = "character", default = NULL,
              help = "The zscore column of eQTL input file [default \"%default\"]"),
  make_option("--ersID", type = "character", default = NULL,
              help = "The rs_id column of eQTL input file [default \"%default\"]"),
  make_option("--jobID", type = "character", default = NULL,
              help = "job id [default \"%default\"]")
)

opt_parser <- OptionParser(option_list=option_list) #解析参数

opt <- parse_args(opt_parser) #解析参数
gp  <- opt$gwas
num_casual <- as.numeric(opt$maxCasual)
rs_id <- opt$rsID
file_ld <- opt$ld
zscore <- opt$zscore
ep <- opt$eQTL
file_eQTL_ld <- opt$eQTLld
ers_id <- opt$ersID
ezscore <- opt$ezscore
job_id <- opt$jobID

stopifnot(file.exists(gp))
stopifnot(file.exists(file_ld))
stopifnot(file.exists(ep))
stopifnot(file.exists(file_eQTL_ld))

# read the file
myGWAS <- read.table(file = gp, header = T)
myeQTL <- read.table(file = ep, header = T)


stopifnot(ncol(myGWAS) >= 2)
stopifnot(zscore %in% colnames(myGWAS))
stopifnot(rs_id %in% colnames(myGWAS))
stopifnot(ncol(myeQTL) >= 2)
stopifnot(ezscore %in% colnames(myeQTL))
stopifnot(ers_id %in% colnames(myeQTL))

# specify the output file
dir_run <- paste0("dir_ecaviar_", job_id)
log_filename <- "log"
log_gwas_set <- file.path(dir_run, paste0(log_filename, "_1_set"))
log_eQTL_set <- file.path(dir_run, paste0(log_filename, "_2_set"))
log_gwas_post <- file.path(dir_run, paste0(log_filename, "_1_post"))
log_eQTL_post <- file.path(dir_run, paste0(log_filename, "_2_post"))
log_col <- file.path(dir_run, paste0(log_filename, "_col"))

# Filter the required data
myGWAS <- myGWAS %>% select(c(rs_id, zscore))
names(myGWAS) <- c("rs_id", "zscore")
myeQTL <- myeQTL %>% select(c(ers_id, ezscore))
names(myeQTL) <- c("rs_id", "zscore")
# Quality Control
zscore_vector <- which(is.na(myGWAS$zscore))
if(length(zscore_vector) != 0){
  zscore_vector <- zscore_vector - 1
}
myGWAS <- filter(as_tibble(myGWAS), !is.na(zscore))

ezscore_vector <- which(is.na(myeQTL$zscore))
if(length(ezscore_vector) != 0){
  ezscore_vector <- ezscore_vector - 1
}
myeQTL <- filter(as_tibble(myeQTL), !is.na(zscore))

ld <- data.table::fread(file_ld) %>% as.matrix
if(length(zscore_vector) != 0){
  ld <- ld[-zscore_vector, -zscore_vector]
}
stopifnot(ncol(ld) == nrow(ld))
diag(ld) <- 1
eQTL_ld <- data.table::fread(file_eQTL_ld) %>% as.matrix
if(length(ezscore_vector) != 0){
  eQTL_ld <- eQTL_ld[-ezscore_vector, -ezscore_vector]
}
stopifnot(ncol(eQTL_ld) == nrow(eQTL_ld))
diag(eQTL_ld) <- 1

stopifnot(all(round(diag(ld), 4) == 1))
stopifnot(all(round(diag(eQTL_ld), 4) == 1))

dir_create <-  dir.create(file.path(getwd(), dir_run), showWarnings = FALSE,
                          recursive = TRUE)

dir_input <- paste0("dir_input_", job_id)
dir_create <-  dir.create(file.path(getwd(), dir_input), showWarnings = FALSE,
                          recursive = TRUE)
# prepare input files
write_delim(myGWAS[,1:2], file.path(dir_input, "gwas.z.txt"),
            delim = " ", col_names = FALSE)
write_delim(myeQTL[,1:2], file.path(dir_input, "eQTL.z.txt"),
            delim = " ", col_names = FALSE)
write.table(ld, file.path(dir_input, "gwas.LD.ld"),
            sep = " ", row.names = FALSE, col.names = FALSE)
write.table(eQTL_ld, file.path(dir_input, "eQTL.LD.ld"),
            sep = " ", row.names = FALSE, col.names = FALSE)

# Run method
tool_input <- paste0("-z ", file.path(dir_input, "gwas.z.txt"),
                     " -z ", file.path(dir_input, "eQTL.z.txt"), " -l ",
                     file.path(dir_input, "gwas.LD.ld"),
                     " -l ", file.path(dir_input, "eQTL.LD.ld"), " -o ", log_filename, " -c ", num_casual)

cmd <- paste0("./eCAVIAR ", tool_input)
print(cmd)
ret_run <- try({
  system(cmd, input = tool_input)
})

# Judge if there is an error in executing the command
ret_status <- ifelse(ret_run == 0, TRUE, FALSE)
stopifnot(ret_status != 0)

# process the output
file.copy(paste0(log_filename, "_col"), dir_run)
file.copy(paste0(log_filename, "_1_set"), dir_run)
file.copy(paste0(log_filename, "_2_set"), dir_run)
file.copy(paste0(log_filename, "_1_post"), dir_run)
file.copy(paste0(log_filename, "_2_post"), dir_run)
if(file.exists(paste0(log_filename, "_1_hist"))){
  file.copy(paste0(log_filename, "_1_hist"), dir_run)
}
if(file.exists(paste0(log_filename, "_2_hist"))){
  file.copy(paste0(log_filename, "_2_hist"), dir_run)
}

gwas_snp <- read.table(file.path(dir_run, paste0(log_filename, "_1_post")), header = TRUE)
eQTL_snp <- read.table(file.path(dir_run, paste0(log_filename, "_2_post")), header = TRUE)
gwas_set <- read.table(file.path(dir_run, paste0(log_filename, "_1_set")), header = FALSE)
eQTL_set <- read.table(file.path(dir_run, paste0(log_filename, "_2_set")), header = FALSE)
stopifnot(ncol(gwas_snp) == 3)
stopifnot(ncol(eQTL_snp) == 3)
names(gwas_snp) <- c("snpID", "prob_in_pCasualSet", "Casual_Post_Prob")
names(eQTL_snp) <- c("snpID", "prob_in_pCasualSet", "Casual_Post_Prob")

# Sort Casual Posterior Probability
gwas_snp <- arrange(gwas_snp, -Casual_Post_Prob) %>%
  mutate(grank = seq(1, n())) %>%
  select(grank, everything())

eQTL_snp <- arrange(eQTL_snp, -Casual_Post_Prob) %>%
  mutate(erank = seq(1, n())) %>%
  select(erank, everything())

write.table(gwas_snp, file.path(dir_run, paste0(log_filename, "_1_post_sorted")),
            sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)
write.table(eQTL_snp, file.path(dir_run, paste0(log_filename, "_2_post_sorted")),
            sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)

# Casual Set
names(gwas_set) <- "snpID"
names(eQTL_set) <- "snpID"
gwas_casual_set <- inner_join(gwas_set, gwas_snp, by = "snpID") %>%
  arrange(grank)
eQTL_casual_set <- inner_join(eQTL_set, eQTL_snp, by = "snpID") %>%
  arrange(erank)

write.table(gwas_casual_set, file.path(dir_run, paste0(log_filename, "_1_set_sorted")),
            sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)
write.table(eQTL_casual_set, file.path(dir_run, paste0(log_filename, "_2_set_sorted")),
            sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)

myCLPP <- read.table(file.path(dir_run, paste0(log_filename, "_col")), header = TRUE)
names(myCLPP) <- c("snpID", "prob_in_pCasualSet", "CLPP")
# sort CLPP
myCLPP <- arrange(myCLPP, -CLPP) %>%
  mutate(rank = seq(1, n())) %>%
  select(rank, everything())

write.table(myCLPP, file.path(dir_run, paste0(log_filename, "_col_sorted")),
           sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)

img <-  ggplot(data = gwas_snp, aes(x = snpID, y = Casual_Post_Prob)) +
               geom_point(aes(color = ifelse(snpID %in% gwas_casual_set$snpID, "red", "skyblue"))) +
               scale_color_identity() +
               labs(title = "Visualisation of Causal SNP in GWAS",
                    x = "SNP",
                    y = "Casual Posterior Probability")+ 
               theme(panel.grid =element_blank())+
               scale_x_discrete(labels=NULL)+
               scale_y_log10()
               
ggsave(file.path(dir_run, "img1.png"), img, width = 10, height = 6, dpi = 300)

img2 <-  ggplot(data = eQTL_snp, aes(x = snpID, y = Casual_Post_Prob)) +
               geom_point(aes(color = ifelse(snpID %in% eQTL_casual_set$snpID, "red", "skyblue"))) +
               scale_color_identity() +
               labs(title = "Visualisation of Causal SNP in eQTL",
                    x = "SNP",
                    y = "Casual Posterior Probability")+ 
               theme(panel.grid =element_blank())+
               scale_x_discrete(labels=NULL)+
               scale_y_log10()
               
ggsave(file.path(dir_run, "img2.png"), img2, width = 10, height = 6, dpi = 300)

img3 <- ggplot(data = myCLPP, aes(x = snpID, y = CLPP)) +
              geom_point(aes(color = "skyblue"), size =1) +
              scale_color_identity() +
              labs(title = "Visualisation of the Colocalization posterior probability (CLPP) for each SNP.",
                   x = "SNP",
                   y = "Colocalization posterior probability")+ 
              theme(panel.background = element_rect(fill = "white"), panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
              scale_x_discrete(labels=NULL)+
              scale_y_log10()

ggsave(file.path(dir_run, "img3.png"), img3, width = 10, height = 6, dpi = 300)