get_STREME_motifs <- function(
  input_dir
){

  file_names <- list.files(input_dir, full.names = TRUE, pattern = "streme.txt", recursive = TRUE)
  cond_names <- strsplit(file_names, split = "/") %>% sapply(function(x){magrittr::extract2(x, length(x)-1)})

  motif_list <- lapply(file_names, function(x){universalmotif::read_meme(x) %>% universalmotif::to_df()})

  add_altname <- function(x, y){
    dplyr::mutate(x, name = paste0("weeder-", rep(y, nrow(x)), "-", addLeadingZeros(1:nrow(x))))
  }

  final <- Reduce(rbind, Map(add_altname, motif_list, cond_names)) %>% universalmotif::to_list()

  return(final)
}
