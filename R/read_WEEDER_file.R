read_WEEDER_file <- function(filename, top_n = 10, filter_weeder = TRUE){

  a <- readLines(filename)

  motifs <- lapply(strsplit(a[seq(1, length(a), 5)], split = "\t"), function(x){return(x[2])})
  A_freq <- lapply(strsplit(a[seq(2, length(a), 5)], split = "\t"), function(x){return(as.numeric(x[2:length(x)]))})
  C_freq <- lapply(strsplit(a[seq(3, length(a), 5)], split = "\t"), function(x){return(as.numeric(x[2:length(x)]))})
  G_freq <- lapply(strsplit(a[seq(4, length(a), 5)], split = "\t"), function(x){return(as.numeric(x[2:length(x)]))})
  T_freq <- lapply(strsplit(a[seq(5, length(a), 5)], split = "\t"), function(x){return(as.numeric(x[2:length(x)]))})

  motif_list <- list()

  for (n in 1:length(motifs)){

    motif <- universalmotif::create_motif(t(matrix(c(A_freq[[n]], C_freq[[n]], G_freq[[n]], T_freq[[n]]), ncol = 4)), alphabet = "DNA", name = motifs[[n]])
    motif_list[[length(motif_list)+1]] <- motif
  }

  if (filter_weeder == TRUE){motifs_final <- motif_list[1:top_n]} else {motifs_final <- motif_list}

  return(motifs_final)
}
