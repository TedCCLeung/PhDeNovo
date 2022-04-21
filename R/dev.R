# Set up package -----------------------------------
#usethis::use_git()
#usethis::use_github()
#usethis::create_github_token()
#usethis::use_mit_license()

# Data manipulation -----------------------------------
# usethis::use_package("dendextend")
# usethis::use_package("circlize")
# usethis::use_package("rlang")

# Bioconductor -----------------------------------
# usethis::use_package("BiocGenerics", min_version = "0.40.0")
# usethis::use_package("GenomeInfoDb", min_version = "1.30.0")
# usethis::use_package("universalmotif", min_version = "1.11.1")
# usethis::use_package("ComplexHeatmap", min_version = "2.0.0")
# usethis::use_package("GenomicRanges", min_version = "1.46.1", type = "Suggests")
# usethis::use_package("GenomicFeatures", min_version = "1.46.1", type = "Suggests")
# usethis::use_package("AnnotationDbi", min_version = "1.40.2", type = "Suggests")
# usethis::use_package("BSgenome.Athaliana.TAIR.TAIR9", min_version = "1.3.1000")
# usethis::use_package("rtracklayer")
# usethis::use_package("cowplot")
# usethis::use_package("Biostrings")

# Tidyverse -----------------------------------
# usethis::use_package("stringr", min_version = "1.4.0")
# usethis::use_package("magrittr", min_version = "2.0.1")
# usethis::use_package("dplyr", min_version = "1.0.7")
# usethis::use_package("tibble", type = "Suggests")
# usethis::use_package("purrr", type = "Suggests")
# usethis::use_package("tidyr", min_version = "1.1.4")
# usethis::use_package("ggplot2", min_version = "3.3.5")
# usethis::use_package("roxygen2"); usethis::use_pipe(export = TRUE)

# Set up NAMESPACE and install -----------------------------------
#devtools::document()
#devtools::load_all()
#devtools::check()
#devtools::install()

# For checking packages needed -----------------------------------

#df_TFfamily_colors <- read.csv("/Users/TedCCLeung/Documents/Projects/Photoperiod/2_analysis/test.csv")
#usethis::use_data(df_TFfamily_colors, overwrite = TRUE)

#CISBP_df <- CISBP_motifset %>% universalmotif::to_df()
#CISBP_families <- data.frame(
#  motif = CISBP_df$name,
#  family = CISBP_df$family
#)
#usethis::use_data(CISBP_families)

#
# seq_path <- list.files("/Users/TedCCLeung/Documents/Projects/Photoperiod/2_analysis/2_pipeline/050_motifEnrich_CISBP_test/0_input/FASTA", full.names = TRUE)
# list_of_seqs <- lapply(seq_path, function(x){y <- Biostrings::readDNAStringSet(x); y[lengths(y) == get_mode(lengths(y))]})
# example_promoters <- list_of_seqs
# names(example_promoters) <- paste0("cluster", addLeadingZeros(1:14))
# usethis::use_data(example_promoters, overwrite = TRUE)


# rDEI_summary <- rDEI_summary[, c("geneID",
#                                  "EQ_DEI", "LD_DEI", "SD_DEI",
#                                  "rDEI_LDEQ", "log2_rDEI_LDEQ",
#                                  "rDEI_SDEQ", "log2_rDEI_SDEQ",
#                                  "rDEI_SDLD", "log2_rDEI_SDLD")]
# usethis::use_data(rDEI_summary, overwrite = TRUE, compress = "xz")





