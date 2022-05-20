run_master <- function(
  dir = "/Users/TedCCLeung/Documents/Projects/Photoperiod/2_analysis/2_pipeline/PhDeNovo/"
){
  all_motifs <- run_input(dir)
  universalmotif::write_homer(all_motifs, file = paste0(dir, "all_motifs.homer_8"),
                              threshold = 8, threshold.type = "logodds.abs", overwrite = TRUE)
  universalmotif::write_meme(all_motifs, file = paste0(dir, "all_motifs.meme"), overwrite = TRUE)
}
