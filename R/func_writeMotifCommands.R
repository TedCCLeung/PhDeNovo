#
#
# parser <- ArgumentParser()
#
# parser$add_argument(
#   "--input_FASTA_dir",
#   default = "../2_pipeline/040_denovomotifs_test/input_FASTA/"
# )
#
# parser$add_argument(
#   "--background_FASTA",
#   default = "../2_pipeline/040_denovomotifs_test/background.fa",
#   help = ""
# )
#
# parser$add_argument(
#   "--add_SBATCH_header",
#   action = "store_true"
# )
#
# parser$add_argument(
#   "--outdir",
#   help = "Output directory"
# )
#
# args <- parser$parse_args()
# ##############################################
# make_STREME_commands <- function(
#   background = NULL,
#   input_file,
#   output_dir
# ){
#
#   ## check for whether background file is needed
#   if (!is.null(background)){
#     bkg_command <- paste0(" --n ", background)
#   } else {bkg_command <- ""}
#
#   command <- paste0(
#     "mkdir -p ", paste0(output_dir), "; ",
#     "streme ",
#     " --oc ", paste0(output_dir),
#     ## The seuqences
#     " --p ", input_file,
#     ## The negative file
#     bkg_command,
#     ## Other settings
#     " --dna ",
#     " --minw 6 ",
#     " --objfun de ",
#     " --pvt 0.10",
#     " -- patience 5"
#   )
#
#   return(command)
# }
#
#
# make_HOMER_commands <- function(
#   background = NULL,
#   input_file,
#   output_dir
# ){
#
#   ## Checking the output directory name
#   if(!endsWith(output_dir, "/")){output_dir <- paste0(output_dir, "/")}
#
#   ## check for whether background file is needed
#   if (!is.null(background)){
#     bkg_command <- paste0(" -fasta ", background)
#   } else {bkg_command <- ""}
#
#   command <- paste0(
#     "mkdir -p ", paste0(output_dir),  ";",
#     " findMotifs.pl ",
#     ## The sequences
#     paste0(input_file),
#     " fasta ",
#     ## The output directory
#     paste0(output_dir),
#     bkg_command,
#     " -len 6,8,10,12",
#     " -S 50"
#   )
#
#   return(command)
# }
#
# make_WEEDER_commands <- function(
#   input_file,
#   background = NULL,
#   output_dir
# ){
#
#   ## Checking the output directory name
#   if(!endsWith(output_dir, "/")){output_dir <- paste0(output_dir, "/")}
#
#   command <- paste0(
#     "mkdir -p ", paste0(output_dir), "; ",
#     #"cd weeder2.0/; ",
#     " weeder2 -f ",
#     paste0(input_file),
#     " -O AT ;",
#     " mv ", paste0(input_file, ".w2"), " ", output_dir, ";",
#     " mv ", paste0(input_file, ".matrix.w2"), " ", output_dir
#   )
#
#   return(command)
# }
#
# make_motif_commands <- function(
#   pos_seq_dir,
#   bkg_file_name = NULL,
#   STREME_output_dir,
#   WEEDER_output_dir,
#   HOMER_output_dir,
#   STREME_command_file,
#   WEEDER_command_file,
#   HOMER_command_file,
#   add_SBATCH_header = FALSE
# ){
#
#   ## make directories to store the commands
#   dir.create(STREME_output_dir, showWarnings = FALSE)
#   dir.create(HOMER_output_dir, showWarnings = FALSE)
#   dir.create(WEEDER_output_dir, showWarnings = FALSE)
#
#   ## get the directory names
#   seq_files = list.files(pos_seq_dir, pattern = ".fa", recursive = TRUE, full.names = TRUE)
#   ## remove the file extension
#   output_dir_names <- sapply(seq_files, function(file){
#     str_trim(head(strsplit(tail(strsplit(file, split = "/")[[1]], 1), split = "\\.")[[1]], 1))
#   })
#   file_number <- length(seq_files)
#
#   ## generate the commands for each tool
#   ## STREME
#   STREME_commands <- unlist(lapply(1:file_number, function(x){
#     make_STREME_commands(
#       background = bkg_file_name,
#       input_file = seq_files[x],
#       output_dir = paste0(STREME_output_dir, output_dir_names[x])
#     )
#   }))
#
#   if (add_SBATCH_header){
#     ## This is the header t facilitate sbatch with Slurm
#     writeLines(
#       c("#!/bin/sh\n\n#SBATCH -n 1\n#SBATCH -c 6\n#SBATCH -J STREME\n#SBATCH -p general\n#SBATCH -t 96:00:00\n#SBATCH --mem-per-cpu=8G\n#SBATCH -o SBATCH_out.txt\n#SBATCH -e SBATCH_err.txt\n",
#         STREME_commands
#       ),
#       STREME_command_file
#     )
#
#   } else {
#     writeLines(STREME_commands, STREME_command_file)
#   }
#
#   ## HOMER
#   HOMER_commands <- unlist(lapply(1:file_number, function(x){
#     make_HOMER_commands(
#       background = bkg_file_name,
#       input_file = seq_files[x],
#       output_dir = paste0(HOMER_output_dir, output_dir_names[x])
#     )
#   }))
#
#   if (add_SBATCH_header){
#     ## This is the header t facilitate sbatch with Slurm
#     writeLines(
#       c("#!/bin/sh\n\n#SBATCH -n 1\n#SBATCH -c 6\n#SBATCH -J HOMER\n#SBATCH -p general\n#SBATCH -t 96:00:00\n#SBATCH --mem-per-cpu=8G\n#SBATCH -o SBATCH_out.txt\n#SBATCH -e SBATCH_err.txt\n",
#         HOMER_commands
#       ),
#       HOMER_command_file
#     )
#
#   } else {
#     writeLines(HOMER_commands, HOMER_command_file)
#   }
#
#   ## WEEDER
#   WEEDER_commands <- unlist(lapply(1:file_number, function(x){
#     make_WEEDER_commands(
#       input_file = seq_files[x],
#       output_dir = paste0(WEEDER_output_dir, output_dir_names[x])
#     )
#   }))
#   writeLines(WEEDER_commands, WEEDER_command_file)
#
#   if (add_SBATCH_header){
#     ## This is the header t facilitate sbatch with Slurm
#     writeLines(
#       c("#!/bin/sh\n\n#SBATCH -n 1\n#SBATCH -c 6\n#SBATCH -J WEEDER\n#SBATCH -p general\n#SBATCH -t 96:00:00\n#SBATCH --mem-per-cpu=8G\n#SBATCH -o SBATCH_out.txt\n#SBATCH -e SBATCH_err.txt\n",
#         WEEDER_commands
#       ),
#       WEEDER_command_file
#     )
#
#   } else {
#     writeLines(WEEDER_commands, WEEDER_command_file)
#   }
#
# }
# ##############################################
#
# ## Make commands for motif finding
# make_motif_commands(
#   pos_seq_dir = args$input_FASTA_dir,
#   bkg_file_name = args$background_FASTA,
#   STREME_output_dir = paste0(args$outdir, "STREME_output/"),
#   WEEDER_output_dir = paste0(args$outdir, "WEEDER_output/"),
#   HOMER_output_dir = paste0(args$outdir, "HOMER_output/"),
#   STREME_command_file = paste0(args$outdir, "STREME_commands.sh"),
#   WEEDER_command_file = paste0(args$outdir, "WEEDER_commands.sh"),
#   HOMER_command_file = paste0(args$outdir, "HOMER_commands.sh"),
#   add_SBATCH_header = args$add_SBATCH_header
# )
# ##############################################
#
