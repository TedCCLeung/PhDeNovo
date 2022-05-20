get_TSS <- function(
  x,
  #x = homer_logodds8,
  upstream = 1000
){

  ## TRANSCRIPTS -------------------
  grange_transcripts <- GenomicFeatures::transcripts(
    TxDb.Athaliana.BioMart.plantsmart28::TxDb.Athaliana.BioMart.plantsmart28
  ) %>% as.data.frame()
  #GenomeInfoDb::seqlevelsStyle(grange_transcripts) <- "TAIR9"
  #names(grange_transcripts) <- grange_transcripts$tx_name


  TSS = grange_transcripts$start
  names(TSS) <- grange_transcripts$tx_name

  strand <- grange_transcripts$strand
  names(strand) <- grange_transcripts$tx_name


  input_grange <- x %>% as.data.frame()
  input_transctripts <- input_grange$seqnames %>% as.character() %>% paste0(".1")
  ## Some genes only have a .2 model
  input_transctripts[!input_transctripts %in% names(TSS)] <-
    input_transctripts[!input_transctripts %in% names(TSS)] %>%
    substr(1, 9) %>%
    paste0(".2")

  input_transctripts[!input_transctripts %in% names(TSS)] <-
    input_transctripts[!input_transctripts %in% names(TSS)] %>%
    substr(1, 9) %>%
    paste0(".3")

  T_start <- TSS[input_transctripts] + input_grange$start*ifelse(strand[input_transctripts] %in% c("+", "*"), 1, -1) - upstream*ifelse(strand[input_transctripts] %in% c("+", "*"), 1, -1)
  T_end <- TSS[input_transctripts] + input_grange$end*ifelse(strand[input_transctripts] %in% c("+", "*"), 1, -1) - upstream*ifelse(strand[input_transctripts] %in% c("+", "*"), 1, -1)

  new_grange <- data.frame(
    seqnames = paste("Chr", substr(input_grange$seqnames, 3, 3)),
    start = pmin(T_start, T_end),
    end = pmax(T_start, T_end),
    strand = input_grange$strand
  ) %>%
    cbind(input_grange[, 6:ncol(input_grange)])

  new_grange$transctript <- input_grange[, 1]

  res <- GenomicRanges::makeGRangesFromDataFrame(new_grange, keep.extra.columns = TRUE)

  return(res)
}
