run_input <- function(
  dir = "/Users/TedCCLeung/Documents/Projects/Photoperiod/2_analysis/2_pipeline/PhDeNovo"
){

  weeder_motifs <- get_WEEDER_motifs(paste0(dir, "/weeder/"))
  streme_motifs <- get_STREME_motifs(paste0(dir, "/streme/"))
  homer_motifs <- get_HOMER_motifs(paste0(dir, "/homer/"))

  all_motifs <- c(weeder_motifs, streme_motifs, homer_motifs)

  return(all_motifs)
}
