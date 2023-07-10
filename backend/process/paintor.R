library('optparse')
library(dplyr)
if (!requireNamespace("readr", quietly = TRUE))
  install.packages("readr")
library(readr)
if (!requireNamespace("data.table", quietly = TRUE))
  install.packages("data.table")
library(ggplot2)

option_list<- list(
  make_option(c("-g", "--gwas"),  type = "character",  default = NULL,
              help = "GWAS Input File [default \"%default\"]"),
  make_option("--ld", type = "character", default = NULL, help = "Input ld Matrix [default \"%default\"]"),
  make_option(c("-a", "--args"), type = "character", default = "",
              help = "additional arguments [default \"%default\"]"),
  make_option("--annots", type = "character", default = FALSE,
              help = "Functional Annotation Matrix [default \"%default\"]"),
  make_option("--annotations", type = "character", default = NULL,
              help = "The names of the annotations to include in model [default \"%default\"]"),
  make_option("--zscore", type = "character", default = NULL,
              help = "The zscore column of GWAS input file [default \"%default\"]"),
  make_option("--rsID", type = "character", default = NULL,
              help = "The zscore column of GWAS input file [default \"%default\"]"),
  make_option("--jobID", type = "character", default = NULL,
              help = "job id [default \"%default\"]")
)

opt_parser <- OptionParser(option_list=option_list) #解析参数
opt_parser <- add_option(opt_parser, "--ngwas", type = "integer",
                         default = NULL, help = "number of gwas data [default \"%default\"]")
opt_parser <- add_option(opt_parser, "--ng", dest = "ngwas")

opt <- parse_args(opt_parser) #解析参数
gp  <- opt$gwas
n_gwas <- as.numeric(opt$ngwas)
arg <- opt$args
rs_id <- opt$rsID
file_ld <- opt$ld
file_annots <- opt$annots
annotations <- opt$annotations
zscore <- opt$zscore
job_id <- opt$jobID

stopifnot(file.exists(gp))
stopifnot(file.exists(file_ld))

# read the file
myGWAS <- read.table(file=gp, header=T)

stopifnot(ncol(myGWAS) >= 2)
stopifnot(zscore %in% colnames(myGWAS))
stopifnot(rs_id %in% colnames(myGWAS))

# Filter the required data
myGWAS <- myGWAS %>% select(c(rs_id, zscore))
names(myGWAS)[c(1, 2)] <- c("rs_id", "zscore")
# Quality Control
zscore_vector <- which(is.na(myGWAS$zscore))
print(zscore_vector)
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
rownames(ld) <- t(snp)
colnames(ld) <- t(snp)
diag(ld) <- 1

stopifnot(all(round(diag(ld), 4) == 1))

if(file_annots == FALSE){
  annots <- tibble(dummy_ones = rep(1, nrow(myGWAS)))
  annotations <- "dummy_ones"
}else if(!file.exists(file_annots)){
  annots <- tibble(dummy_ones = rep(1, nrow(myGWAS)))
  annotations <- "dummy_ones"
}else{
  annots <- read.table(file=file_annots, header=T)
  if(length(zscore_vector) != 0){
    ld <- ld[-zscore_vector,]
  }
}

dir_run <- paste0("dir_paintor_", job_id)
dir_create <-  dir.create(file.path(getwd(), dir_run), showWarnings = FALSE,
                          recursive = TRUE)

dir_input <- paste0("dir_input_", job_id)
dir_create <-  dir.create(file.path(getwd(), dir_input), showWarnings = FALSE,
                          recursive = TRUE)
# prepare input files
write_delim(myGWAS[,1:2], file.path(dir_input, "locus"),
           delim = " ", col_names = TRUE)
write.table(ld, file.path(dir_input, "locus.ld"),
            sep = " ", row.names = FALSE, col.names = FALSE)
write.table(annots, file.path(dir_input, "locus.annotations"),
            sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)

master <- "locus"
write_lines(master, file.path(dir_input, "input.files"))

# Run method
annotations_str <- paste(annotations,collapse = ",")
if(!is.null(n_gwas)){
  tool_input <- paste0("-num_samples ", n_gwas, " ")
}
tool_input <- paste0("-input ", file.path(dir_input, "input.files"), " -in ", dir_input, "/ -out ", dir_run, "/ -Zhead zscore -LDname ld -annotations ",
                     annotations_str, " ", arg)

cmd <- paste0("./PAINTOR ", tool_input)
print(cmd)

ret_run <- try({
  system(cmd, input = tool_input)
})

# Judge if there is an error in executing the command
ret_status <- ifelse(ret_run == 0, TRUE, FALSE)
stopifnot(ret_status != 0)

# process the output
result <- read.delim(file.path(dir_run, "locus.results"), sep = " ")
stopifnot(ncol(result) == 3)

base <- read.delim(file.path(dir_run, "Enrichment.Values"), sep = " ")
stopifnot(nrow(base) == 1)

gamma_val <- as.numeric(base)
baseline_prob <- 1/(1 + exp(gamma_val[1]))
prior_prob <- 1/(1 + exp(gamma_val[1] + gamma_val[-1]))
enrich_prob <- c(baseline_prob, prior_prob)

enrich <- data.frame(annot = colnames(base),
                     gamma = gamma_val, enrich_prob)

write.table(enrich, file.path(dir_run, "locus.enrich"),
            sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)

img <- ggplot(data = result, aes(x = rs_id, y = Posterior_Prob)) +
              geom_point(aes(color = "skyblue"), size =1) +
              scale_color_identity() +
              labs(title = "Visualisation of results",
                   x = "SNP",
                   y = "Posterior Inclusion Probability")+ 
              theme(panel.background = element_rect(fill = "white"), panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
              scale_x_discrete(labels=NULL)+
              scale_y_log10()

ggsave(file.path(dir_run, "img.png"), img, width = 10, height = 6, dpi = 300)