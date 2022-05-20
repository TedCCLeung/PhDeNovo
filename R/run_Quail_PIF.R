process_Quail_PIF <- function(

){

  df_data <- utils::read.delim("data-raw/PHQuail_PIF_data.txt")

  df_data$GeneID %>% unique() %>%
    utils::write.table("data-raw/PIF_genes.txt", row.names = FALSE, quote = FALSE, col.names = FALSE)

  CISBP_motifset %>% universalmotif::filter_motifs(altname = c("PIF1", "PIF3", "PIF4", "PIF5")) %>%
    universalmotif::write_homer(file = "data-raw/PIF_motifs.homer",
                                threshold.type = "logodds.abs", threshold = 8)
}


check_Quail_PIF <- function(

){

  df_data <- utils::read.delim("data-raw/PHQuail_PIF_data.txt")
  df_data <- df_data[df_data$Distance.to.TSS.from.summit.center < 1000, ]

  PIF_grange <- data.frame(
    seqnames = df_data$Chromosome,
    start = df_data$Summit.start,
    end = df_data$Summit.end,
    strand = gsub("_", "*", df_data$TSS.strand),
    motif = df_data$TF,
    gene = df_data$GeneID
  ) %>% GenomicRanges::makeGRangesFromDataFrame(keep.extra.columns = TRUE)
  GenomeInfoDb::seqlevels(PIF_grange) <- c("Chr1", "Chr2", "Chr3", "Chr4", "Chr5", "ChrM", "ChrC")
  GenomeInfoDb::seqlengths(PIF_grange) <- c(30427671, 19698289, 23459830, 18585056, 26975502, 366924, 154478)
  GenomeInfoDb::seqlevelsStyle(PIF_grange) <- "TAIR9"
  GenomicRanges::trim(PIF_grange)

  homer_logodds8 <- homerMotif_to_GRange(
    homer_file = "data-raw/PIF_mappings_8.txt",
    upstream = 1000,
    downstream = 10
  )

  ## Convert motif ID to gene name
  PIF_motifs <- CISBP_motifset %>% universalmotif::filter_motifs(altname = c("PIF1", "PIF3", "PIF4", "PIF5")) %>%
    universalmotif::to_df()
  PIF_conversion <- PIF_motifs$altname
  names(PIF_conversion) <- PIF_motifs$name
  homer_logodds8$TF <- PIF_conversion[homer_logodds8$motif]

  ## Overlap
  overlap_grange <- IRanges::subsetByOverlaps(PIF_grange, homer_logodds8)

  df_PIF <- PIF_grange %>% as.data.frame()
  df_homer <- homer_logodds8 %>% as.data.frame()
  df_homer_mapped <- homer_logodds8 %>% genome_to_transcript() %>% as.data.frame()
  #View(df_homer)
  #View(df_homer_mapped)

  df_overlap <- overlap_grange %>% as.data.frame()
}
