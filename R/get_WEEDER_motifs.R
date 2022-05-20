get_WEEDER_motifs <- function(
  input_dir
){

  file_names <- list.files(input_dir, full.names = TRUE, pattern = "*matrix*", recursive = TRUE)
  cond_names <- strsplit(file_names, split = "/") %>% sapply(utils::tail, 1) %>% strsplit(file_names, split = "\\.") %>% sapply(utils::head, 1)

  motif_list <- lapply(file_names, function(x){read_WEEDER_file(x) %>% universalmotif::to_df()})

  add_altname <- function(x, y){
    dplyr::mutate(x, name = paste0("weeder-", rep(y, nrow(x)), "-", addLeadingZeros(1:nrow(x))))
  }

  final <- Reduce(rbind, Map(add_altname, motif_list, cond_names)) %>% universalmotif::to_list()

  return(final)
}
