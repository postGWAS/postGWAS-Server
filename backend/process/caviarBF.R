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
  make_option("--jobID", type = "character", default = NULL,
              help = "job id [default \"%default\"]"),
  make_option(c("-c", "--maxCasual"), type = "integer", default = 1,
              help = "the maximal number of causal variants in the model [default \"%default\"]"),
  make_option("--zscore", type = "character", default = "zscore",
              help = "The zscore column of GWAS input file [default \"%default\"]"),
  make_option("--rsID", type = "character", default = "rs_id",
              help = "The rs_id column of GWAS input file [default \"%default\"]")
)

opt_parser <- OptionParser(option_list=option_list) #解析参数
opt_parser <- add_option(opt_parser, "--ngwas", type = "integer", default = NULL, help = "number of gwas data")
opt_parser <- add_option(opt_parser, "--ng", dest = "ngwas")

opt <- parse_args(opt_parser) #解析参数
gp  <- opt$gwas
n_gwas <- as.numeric(opt$ngwas)
num_casual <- as.numeric(opt$maxCasual)
job_id <- opt$jobID
rs_id <- opt$rsID
file_ld <- opt$ld
zscore <- opt$zscore

stopifnot(file.exists(gp))
stopifnot(file.exists(file_ld))

# read the file
myGWAS <- read.table(file=gp, header=T)
num_snp <- nrow(myGWAS)

stopifnot(ncol(myGWAS) >= 2)
stopifnot(zscore %in% colnames(myGWAS))
stopifnot(rs_id %in% colnames(myGWAS))

# Filter the required data
myGWAS <- myGWAS %>% select(c(rs_id, zscore))
names(myGWAS)[c(1, 2)] <- c("rs_id", "zscore")
zscore_vector <- which(is.na(myGWAS$zscore))
if(length(zscore_vector) != 0){
  zscore_vector <- zscore_vector - 1
}

# Quality Control
myGWAS <- filter(as_tibble(myGWAS), !is.na(zscore))

snp <- myGWAS %>% select("rs_id")
ld <- data.table::fread(file_ld) %>% as.matrix
if(length(zscore_vector) != 0){
  ld <- ld[-zscore_vector, -zscore_vector]
}
stopifnot(ncol(ld) == nrow(ld))
diag(ld) <- 1

stopifnot(all(round(diag(ld), 4) == 1))

# specify the output file
dir_run <- paste0("dir_caviar_", job_id)
dir_create <-  dir.create(file.path(getwd(), dir_run), showWarnings = FALSE,
                          recursive = TRUE)

dir_input <- paste0("dir_input_", job_id)
dir_create <-  dir.create(file.path(getwd(), dir_input), showWarnings = FALSE,
                          recursive = TRUE)
# prepare input files
write_delim(myGWAS[,1:2], file.path(dir_input, "myfile.Z"),
            delim = " ", col_names = FALSE)
write.table(ld, file.path(dir_input, "myfile.LD"),
            sep = " ", row.names = FALSE, col.names = FALSE)

# Run method
tool_input <- paste0("-z ", file.path(dir_input, "myfile.Z"), " -r ", file.path(dir_input, "myfile.LD"),
                     " -t 0 -a 0.1,0.2,0.4 -n ", n_gwas, " -c ", num_casual," -o ", file.path(dir_run, "myfile.bf"))


cmd <- paste0("./caviarbf ", tool_input)
print(cmd)
ret_run <- try({
  system(cmd, input = tool_input)
})

# Judge if there is an error in executing the command
ret_status <- ifelse(ret_run == 0, TRUE, FALSE)
stopifnot(ret_status != 0)

model_input <- paste0("-i ", file.path(dir_run, "myfile.bf"), " -m ", num_snp, " -p 0 -o ",
                      file.path(dir_run, "myfile.bf.prior0"))
model_cmd <- paste0("./model_search ", model_input)
print(model_cmd)

ret_run <- try({
  system(model_cmd, input = tool_input)
})

# Judge if there is an error in executing the command
ret_status <- ifelse(ret_run == 0, TRUE, FALSE)
stopifnot(ret_status != 0)

# 读取myfile.bf.prior0.marginal文件
marg <- read.table(file.path(dir_run, "myfile.bf.prior0.marginal"), header=F)

# 将col和PIP两列命名
names(marg) <- c("col", "PIP")

# 根据col列匹配rs_id列
merged_data <- merge(marg, myGWAS, by.x="col", by.y=0)

# 删除col和zscore列
merged_data <- subset(merged_data, select=c("rs_id", "PIP"))
merged_data <- merged_data[order(merged_data$PIP, decreasing = TRUE), ]

# 存储到myfile.bf.prior0.rsid.marginal文件中
write.table(merged_data, file=file.path(dir_run, "myfile.bf.prior0.rsid.marginal"), quote=FALSE, sep="\t", row.names=FALSE)

img <- ggplot(data = merged_data, aes(x = rs_id, y = PIP)) +
              geom_point(aes(color = "skyblue"), size =1) +
              scale_color_identity() +
              labs(title = "Visualisation of results",
                   x = "SNP",
                   y = "Posterior Inclusion Probability")+ 
              theme(panel.background = element_rect(fill = "white"), panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
              scale_x_discrete(labels=NULL)+
              scale_y_log10()

ggsave(file.path(dir_run, "img.png"), img, width = 10, height = 6, dpi = 300)