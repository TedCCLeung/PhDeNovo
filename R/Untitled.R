# if (FALSE){
#
#
#   df_PIF <- PIF_grange %>% as.data.frame()
#
#   df_map_tx <- as.data.frame(homer_logodds8)
#   df_map_genome <- genome_to_transcript(homer_logodds8) %>% as.data.frame()
#
#
#   View(df_PIF)
#   View(df_map_tx)
#   View(df_map_genome)
#
#
#   genome <- BSgenome.Athaliana.TAIR.TAIR9::BSgenome.Athaliana.TAIR.TAIR9
#
#   mapping_result <- genome_to_transcript(homer_logodds8)
#   mapping_result[mapping_result$transctript == "AT5G66870"]
#
#   a <- Biostrings::getSeq(genome, )
#
#   promoters <- get_promoter(
#     gene_models = c("AT5G66870.1"),
#     upstream = 1000,
#     downstream = 0
#   )
#   promoters %>% Biostrings::subseq(start = 289, width = 9) %>%
#     Biostrings::reverseComplement()
#
#
# }
