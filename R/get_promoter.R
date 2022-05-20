get_promoter <- function(
  gene_models,
  upstream = 1000,
  downstream = 500
){

  ## TRANSCRIPTS -------------------
  grange_promoters <- GenomicFeatures::promoters(
    TxDb.Athaliana.BioMart.plantsmart28::TxDb.Athaliana.BioMart.plantsmart28,
    upstream = upstream, downstream = downstream
  )[gene_models,] %>% suppressWarnings()
  suppressWarnings(GenomeInfoDb::seqlengths(grange_promoters) <- c(30427671, 19698289, 23459830, 18585056, 26975502, 366924, 154478))
  pr.ranges <- GenomicRanges::trim(grange_promoters)
  GenomeInfoDb::seqlevelsStyle(grange_promoters) <- "TAIR9"

  genome <- BSgenome.Athaliana.TAIR.TAIR9::BSgenome.Athaliana.TAIR.TAIR9

  return(Biostrings::getSeq(genome, grange_promoters))
}



