#!/usr/bin/env Rscript

###################PACKAGES###################
## Load packages and functions
source("func_loadPackages.R")
###################ARGPARSE###################
parser <- ArgumentParser()

parser$add_argument(
  "--geneList_files",
  nargs = "+",
  help = "String of file name of cluster summary"
  ,default = "../2_pipeline/000_geneLists/detected.txt"
)

parser$add_argument(
  "--merge_all_genes",
  action = "store_true"
)

parser$add_argument(
  "--outfile",
  help = "Output file"
  ,default = "../2_pipeline/050_mapMotifs/input_FASTA.fa"
)

parser$add_argument(
  "--outdir",
  help = "Output directory"
  ,default = "../2_pipeline/050_mapMotifs/input_motifs/"
)

parser$add_argument(
  "--upstream",
  default=1000,
  type="integer",
  help="The number of base pairs upstream of TSS"
)

parser$add_argument(
  "--downstream",
  default=500,
  type="integer",
  help="The number of base pairs downstream of TSS"
)

parser$add_argument(
  "--rDEI",
  default=1,
  type="double",
  help="Filter for genes that are below an rDEI threashold"
)

parser$add_argument(
  "--rDEI_file"
  , default = "../2_pipeline/020_classify/summary_rDEI.csv"
)

parser$add_argument(
  "--sqlite"
  , default = "../0_data/B_userData/processed_files/TAIR10.sqlite"
)

args <- parser$parse_args()
##############################################
filter_genes_by_rDEI <- function(
  geneID,
  rDEI_threshold,
  rDEI_file
){
  df_rDEI = read.csv(rDEI_file)
  rDEI_cols <- colnames(df_rDEI)[startsWith(colnames(df_rDEI), "log2_rDEI_")]
  
  max_rDEI <- suppressWarnings(apply(abs(df_rDEI[, rDEI_cols]), 1, function(m){max(m, na.rm = TRUE)}))
  max_rDEI[is.infinite(max_rDEI) | is.na(max_rDEI)] <- 0
  high_rDEI_genes <- df_rDEI[max_rDEI > log2(rDEI_threshold), "geneID"]
  genes <- geneID[geneID %in% high_rDEI_genes]
  return(genes)
}

get_promoters <- function(
  upstream = 1500,
  downstream = 0,
  gene_models = c("AT3G61060.1", "AT3G61060.2"),
  sqlite_database
){
  
  ## 01. Get the location of promoter
  txdb <- loadDb(sqlite_database)
  valid.genes <- transcripts(txdb)$tx_name
  gene_models <- gene_models[gene_models %in% valid.genes]
  print(paste0("invalid genes: ", as.character(length(gene_models[!(gene_models %in% valid.genes)]))))
  pr.ranges <- promoters(txdb, upstream = upstream, downstream = downstream)[gene_models,]
  ## Add the length of chromosomes in bp manually
  seqlengths(pr.ranges) <- c(30427671, 19698289, 23459830, 18585056, 26975502, NA, NA)
  pr.ranges <- trim(pr.ranges)
  seqlevelsStyle(pr.ranges) <- "TAIR9"
  
  ## 02. Get the genome sequence (TAIR9 and TAIR10 are identical)
  genome <- BSgenome.Athaliana.TAIR.TAIR9
  
  ## 03. Get the sequence and output to a fasta file
  return(getSeq(genome, pr.ranges))
}

## Getting 5'UTR
get_fiveUTR <- function(
  gene_models = c("AT3G61060.1", "AT3G61060.2"),
  sqlite_database
){
  
  ## 01. Get the location of promoter
  txdb <- loadDb(sqlite_database)
  valid.genes <- transcripts(txdb)$tx_name
  gene_models <- gene_models[gene_models %in% valid.genes]
  print(paste0("invalid genes: ", as.character(length(gene_models[!(gene_models %in% valid.genes)]))))
  five.utr <- fiveUTRsByTranscript(txdb, use.names = TRUE)
  genes.with.five <- names(five.utr)
  gene_models <- gene_models[gene_models %in% genes.with.five]
  print(paste0("genes with unknown 5'UTR: ", as.character(gene_models[!(gene_models %in% genes.with.five)])))
  five.utr <- five.utr[gene_models]
  seqlevelsStyle(five.utr) <- "TAIR9"
  seqlengths(five.utr) <- c(30427671, 19698289, 23459830, 18585056, 26975502, NA, NA)
  five.utr <- trim(five.utr)
  five.utr <- unlist(five.utr)
  
  ## 02. Get the genome sequence (TAIR9 and TAIR10 are identical)
  genome <- BSgenome.Athaliana.TAIR.TAIR9
  
  ## 03. Get the sequence and output to a fasta file
  return(getSeq(genome, five.utr))
}

## Getting promoter plus 5'UTR
get_prom_five <- function(
  gene_models,
  prom.upstream = 2000,
  sqlite_database
){
  
  prom <- get_promoters(
    upstream = prom.upstream,
    downstream = 0,
    gene_models = gene_models,
    sqlite_database = sqlite_database
  )
  
  five <- get_fiveUTR(
    gene_models = gene_models,
    sqlite_database = sqlite_database
  )
  
  res <- DNAStringSet(x = "A")
  for (k in 1:length(gene_models)){
    gene <- gene_models[k]
    if ((gene %in% names(prom)) & (gene %in% names(five))){
      gene.res <- xscat(prom[gene], five[gene])
      names(gene.res) <- gene
      res <- c(res, gene.res)
    } else if ((gene %in% names(prom))){
      res <- c(res, prom[gene])
    }
  }
  
  return(res[2:length(res)])
}
##############################################
read_genes <- function(x){y <- readLines(file(x)); close(file(x)); return(sort(y))}
##############################################


## If all the input genes are to be pulled together to produce one FASTA file
if (args$merge_all_genes) {
  
  ##############################################
  ## This part is repeated. 
  ##############################################
  
  genes <- sort(unlist(lapply(args$geneList_files, read_genes)))
  
  ## convert gene IDs to transcript IDs (also filter by rDEI if necessary)
  if (is.null(args$args$rDEI_file) | is.null(args$args$rDEI_file)){
    transcripts <- paste0(genes, ".1")
  } else {
    transcripts <- filter_genes_by_rDEI(
      geneID = genes_to_map,
      rDEI_threshold = args$rDEI,
      rDEI_file = args$rDEI_file
    )
    transcripts <- paste0(transcripts, ".1")
  }
  
  ## output the promoters to FASTA files
  seqs <- get_promoters(
    upstream = args$upstream,
    downstream = args$downstream,
    gene_models = transcripts,
    sqlite_database = args$sqlite
  )
  writeXStringSet(seqs, filepath = args$outfile)
  
  ##############################################
  
} else {
  
  gene_list <- lapply(args$geneList_files, read_genes)
  
  ## convert gene IDs to transcript IDs (also filter by rDEI if necessary)
  if (is.null(args$args$rDEI_file) | is.null(args$args$rDEI_file)){
    transcript_list <- lapply(gene_list, function(x){paste0(x, ".1")})
  } else {
    transcript_list <- lapply(gene_list, function(genes){
      
      filtered_genes <- filter_genes_by_rDEI(
        geneID = genes,
        rDEI_threshold = args$rDEI,
        rDEI_file = args$rDEI_file
      )
      return(paste0(filtered_genes, ".1"))
    })
  }
  
  file_names <- lapply(args$geneList_files, function(x){
    f_name <- str_trim(tail(strsplit(x, split = "/")[[1]], n = 1))
    out_name <- str_trim(paste0(head(strsplit(f_name, split = "\\.")[[1]], n = 1), ".fa"))
    return(out_name)
    })

  ## output the promoters to FASTA files
  
  file_number <- length(file_names)
  
  for (k in 1:file_number){
    
    seqs <- get_promoters(
      upstream = args$upstream,
      downstream = args$downstream,
      gene_models = transcript_list[[k]],
      sqlite_database = args$sqlite
    )
    writeXStringSet(seqs, filepath = paste0(args$outdir, file_names[k]))
  }
}

