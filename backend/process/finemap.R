options(repos = c(CRAN = "https://cloud.r-project.org/"))
library('optparse')
library(dplyr)
if (!requireNamespace("readr", quietly = TRUE))
  install.packages("readr")
library(readr)
if (!requireNamespace("data.table", quietly = TRUE))
  install.packages("data.table")
library(ggplot2)

option_list<- list(
  make_option(c("-g", "--gwas"),  type = "character",  default = NULL,  help = "GWAS Input File [default \"%default\"]"),
  make_option("--ld", type = "character", default = NULL, help = "Input ld Matrix [default \"%default\"]"),
  make_option("--beta", type = "character", default = "beta", help = "the beta column of GWAS Input File [default \"%default\"]"),
  make_option("--rsID", type = "character", default = "rs_id", help = "the rs_id column of GWAS Input File [default \"%default\"]"),
  make_option("--chr", type = "character", default = "chromosome", help = "the chromosome column of GWAS Input File [default \"%default\"]"),
  make_option("--pos", type = "character", default = "position", help = "the position column of GWAS Input File [default \"%default\"]"),
  make_option("--A1", type = "character", default = "allele1", help = "the allele1 column of the GWAS Input File [default \"%default\"]"),
  make_option("--A2", type = "character", default = "allele2", help = "the allele2 column of the GWAS Input File [default \"%default\"]"),
  make_option("--maf", type = "character", default = "maf", help = "the maf column of the GWAS Input File [default \"%default\"]"),
  make_option("--se", type = "character", default = "se", help = "the se column of the GWAS Input File [default \"%default\"]"),
  make_option(c("-c", "--maxCasual"), type = "integer", default = 5,
              help = "the maximal number of causal variants in the model [default \"%default\"]"),
  make_option("--jobID", type = "character", default = NULL, help = "job id [default \"%default\"]")
)

opt_parser <- OptionParser(option_list=option_list) #解析参数
opt_parser <- add_option(opt_parser, "--ngwas", type = "integer", default = FALSE, help = "number of gwas data")
opt_parser <- add_option(opt_parser, "--ng", dest = "ngwas")

opt <- parse_args(opt_parser) #解析参数
gp  <- opt$gwas
n_gwas <- as.numeric(opt$ngwas)
file_ld <- opt$ld
beta <- opt$beta
rs_id <- opt$rsID
chr <- opt$chr
pos <- opt$pos
A1 <- opt$A1
A2 <- opt$A2
maf <- opt$maf
se <- opt$se
num_casual <- as.numeric(opt$maxCasual)
job_id <- opt$jobID
print(num_casual)

stopifnot(file.exists(gp))
stopifnot(file.exists(file_ld))

# read the file
myGWAS <- read.table(file=gp, header=T)

stopifnot(ncol(myGWAS) >= 8)
stopifnot(beta %in% colnames(myGWAS))
stopifnot(se %in% colnames(myGWAS))
stopifnot(maf %in% colnames(myGWAS))
stopifnot(rs_id %in% colnames(myGWAS))
stopifnot(A1 %in% colnames(myGWAS))
stopifnot(A2 %in% colnames(myGWAS))
stopifnot(chr %in% colnames(myGWAS))
stopifnot(pos %in% colnames(myGWAS))

# Filter the required data
myGWAS <- filter(myGWAS, !is.na(beta))
myGWAS <- filter(myGWAS, !is.na(se))
myGWAS <- filter(myGWAS, !is.na(maf))

myGWAS <- myGWAS[,c(rs_id, chr, pos, A1, A2, maf, beta, se)]
names(myGWAS)[c(1,2,3,4,5,6,7,8)] <- c("rsid","chromosome", "position", "allele1", "allele2", "maf", "beta", "se")

snp <- myGWAS[,"rsid"]
print(colnames(myGWAS))
ld <- data.table::fread(file_ld) %>% as.matrix
stopifnot(ncol(ld) == nrow(ld))
rownames(ld) <- snp
colnames(ld) <- snp
diag(ld) <- 1

stopifnot(all(round(diag(ld), 4) == 1))

dir_run <- paste0("dir_finemap_", job_id)
dir_input <- paste0("dir_input_", job_id)

dir_create <-  dir.create(file.path(getwd(), dir_run), showWarnings = FALSE,
                          recursive = TRUE)
dir_create1 <-  dir.create(file.path(getwd(), dir_input), showWarnings = FALSE,
                          recursive = TRUE)

# prepare input files
write_delim(myGWAS[,1:8], file.path(dir_input, "data.z"),
            delim = " ", col_names = TRUE)
write.table(ld, file.path(dir_input, "data.ld"),
            sep = " ", row.names = FALSE, col.names = FALSE)

master <- c("z;ld;snp;config;cred;log;n_samples",
            paste0(file.path(dir_input, "data.z"), ";", file.path(dir_input, "data.ld"), ";", file.path(dir_run, "data.snp"), ";", 
            file.path(dir_run, "data.config"), ";", file.path(dir_run, "data.cred"), ";", file.path(dir_run, "data.log"), ";", n_gwas))
write_lines(master, file.path(dir_input, "data.master"))

# Run method
tool_input <- paste0("--sss --log --n-causal-snps ",num_casual, " --in-files ", file.path(dir_input, "data.master"))

cmd <- paste0("./finemap_v1.4.1_x86_64 ", tool_input)

ret_run <- try({
  system(cmd, input = tool_input)
})

# Judge if there is an error in executing the command
ret_status <- ifelse(ret_run == 0, TRUE, FALSE)
stopifnot(ret_status != 0)

snp <- read.table(file.path(dir_run, "data.snp"), header=T)
snp <- subset(snp, select=c("rsid", "prob"))

img <- ggplot(data = snp, aes(x = rsid, y = prob)) +
              geom_point(aes(color = "skyblue"), size =1) +
              scale_color_identity() +
              labs(title = "Visualisation of results",
                   x = "SNP",
                   y = "Posterior Inclusion Probability")+ 
              theme(panel.background = element_rect(fill = "white"), panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
              scale_x_discrete(labels=NULL)+
              scale_y_log10()

ggsave(file.path(dir_run, "img.png"), img, width = 10, height = 6, dpi = 300)

cng <- read.table(file.path(dir_run, "data.config"), header=T)

if(nrow(cng) > 5) {
  cng <- head(cng, n = 5)
}

img2 <- ggplot(data = cng, aes(x = prob, y = rank, label = config)) +
               geom_bar(aes(fill = "prob"), stat = "identity", orientation = "y") +
               scale_fill_manual(values = "skyblue") +
               geom_text(aes(x = prob / 2 + 0.05, y = rank, label = config), color = "black", size = 5) +
               geom_text(aes(x = -0.02, y = rank, label = prob), color = "darkgray", size = 4) +
               labs(x = "Posterior Probability", y = "Rank", title = "Top Configurations") +
               theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill = "white"), panel.grid.major = element_blank(), panel.grid.minor = element_blank())

ggsave(file.path(dir_run, "img2.png"), img2, width = 15, height = 6, dpi = 300)