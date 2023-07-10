library('optparse')
library(dplyr)
if (!requireNamespace("readr", quietly = TRUE))
  install.packages("readr")
library(readr)
if (!requireNamespace("magrittr", quietly = TRUE))
  install.packages("magrittr")
library(magrittr)
if (!requireNamespace("data.table", quietly = TRUE))
  install.packages("data.table")
library(ggplot2)

option_list<- list(
  make_option(c("-g", "--gwas"),  type = "character",  default = NULL,
              help = "GWAS Input File [default \"%default\"]"),
  make_option("--ld", type = "character", default = NULL, help = "Input ld Matrix [default \"%default\"]"),
  make_option(c("-c", "--maxCasual"), type = "integer", default = 1,
              help = "the maximal number of causal variants [default \"%default\"]"),
  make_option("--zscore", type = "character", default = NULL,
              help = "The zscore column of GWAS input file [default \"%default\"]"),
  make_option("--rsID", type = "character", default = NULL,
              help = "The rs_id column of GWAS input file [default \"%default\"]"),
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
job_id <- opt$jobID

stopifnot(file.exists(gp))
stopifnot(file.exists(file_ld))

# read the file
myGWAS <- read.table(file=gp, header=T)

stopifnot(ncol(myGWAS) >= 2)
stopifnot(zscore %in% colnames(myGWAS))
stopifnot(rs_id %in% colnames(myGWAS))

# specify the output file
dir_run <- paste0("dir_caviar_", job_id)
log_filename <- "log"
log_set <- file.path(dir_run, paste0(log_filename,"_set"))
log_post <- file.path(dir_run, paste0(log_filename, "_post"))
log_log <- file.path(dir_run, paste0(log_filename, ".log"))

# Filter the required data
myGWAS <- myGWAS %>% select(c(rs_id, zscore))
names(myGWAS) <- c("rs_id", "zscore")
# Quality Control
zscore_vector <- which(is.na(myGWAS$zscore))
if(length(zscore_vector) != 0){
  zscore_vector <- zscore_vector - 1
}
myGWAS <- filter(as_tibble(myGWAS), !is.na(zscore))

snp <- myGWAS %>% select("rs_id")
ld <- data.table::fread(file_ld) %>% as.matrix
if(length(zscore_vector) != 0){
  ld <- ld[-zscore_vector, -zscore_vector]
}
stopifnot(ncol(ld) == nrow(ld))
diag(ld) <- 1

stopifnot(all(round(diag(ld), 4) == 1))

dir_create <-  dir.create(file.path(getwd(), dir_run), showWarnings = FALSE,
                          recursive = TRUE)

dir_input <- paste0("dir_input_", job_id)
dir_create <-  dir.create(file.path(getwd(), dir_input), showWarnings = FALSE,
                          recursive = TRUE)
# prepare input files
write_delim(myGWAS[,1:2], file.path(dir_input, "z.txt"),
            delim = " ", col_names = FALSE)
write.table(ld, file.path(dir_input, "ld.txt"),
            sep = " ", row.names = FALSE, col.names = FALSE)

# Run method
tool_input <- paste0("-z ", file.path(dir_input, "z.txt"), " -l ", file.path(dir_input, "ld.txt"), " -o ", log_filename, " -c ", num_casual)

cmd <- paste0("./CAVIAR ", tool_input)
ret_run <- try({
  system(cmd, input = tool_input)
})
print(cmd)
# Judge if there is an error in executing the command
ret_status <- ifelse(ret_run == 0, TRUE, FALSE)
stopifnot(ret_status != 0)

# process the output
file.copy(paste0(log_filename, "_post"), dir_run)
file.copy(paste0(log_filename, "_set"), dir_run)
if(file.exists(paste0(log_filename, "_hist"))){
  file.copy(paste0(log_filename, "_hist"), dir_run)
}

snp <- read.table(file.path(dir_run, paste0(log_filename, "_post")), header = TRUE)
mySet <- read.table(file.path(dir_run, paste0(log_filename, "_set")), header = FALSE)
stopifnot(ncol(snp) == 3)
names(snp) <- c("snpID", "prob_in_pCasualSet", "Casual_Post_Prob")

# Sort Casual Posterior Probability
snp <- arrange(snp, -Casual_Post_Prob) %>%
  mutate(rank = seq(1, n())) %>%
  select(rank, everything())

write.table(snp, file.path(dir_run, paste0(log_filename, "_post_sorted")),
            sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)

# Casual Set
names(mySet) <- "snpID"
casual_set <- inner_join(mySet, snp, by = "snpID") %>% 
    arrange(rank)

write.table(casual_set, file.path(dir_run, paste0(log_filename, "_set_sorted")),
            sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)

img <-  ggplot(data = snp, aes(x = snpID, y = Casual_Post_Prob)) +
               geom_point(aes(color = ifelse(snpID %in% mySet$snpID, "red", "skyblue"))) +
               scale_color_identity() +
               labs(title = "Visualisation of results",
                    x = "SNP",
                    y = "Casual Posterior Probability")+ 
               theme(panel.grid =element_blank())+
               scale_x_discrete(labels=NULL)+
               scale_y_log10()
               
ggsave(file.path(dir_run, "img.png"), img, width = 10, height = 6, dpi = 300)