# read_homer_modified <- function(
#   ## The read_homer function in the universalmotif package has some issues with the C++ code
#   ## This one fixes it by ignoring the calculation of a p value score
#   file,
#   skip = 0
# ){
#
#   hidden <- setdiff(p_funs("universalmotif", TRUE), p_funs("universalmotif"))
#   invisible(lapply(hidden, function(x) {
#     a <- strtrim(x, 1) == "%"
#     b <- substring(x, nchar(x)) == "%"
#     if (a && b) {x2 <- paste0("`", x, "`")} else {x2 <- x}
#     assign(x, eval(parse(text=paste0("universalmotif", ":::", x2))),
#            envir = .GlobalEnv)
#   }))
#
#   args <- as.list(environment())
#   char_check <- check_fun_params(list(file = args$file), 1,
#                                  FALSE, TYPE_CHAR)
#   num_check <- check_fun_params(list(skip = args$skip), 1,
#                                 FALSE, TYPE_NUM)
#   all_checks <- c(char_check, num_check)
#   if (length(all_checks) > 0)
#     stop(all_checks_collapse(all_checks))
#   raw_lines <- readLines(con <- file(file))
#   close(con)
#   if (skip > 0)
#     raw_lines <- raw_lines[-seq_len(skip)]
#   raw_lines <- raw_lines[raw_lines != ""]
#   headers <- which(grepl("^>", raw_lines))
#   motif_starts <- headers + 1
#   if (length(headers) == 1)
#     motif_stops <- length(raw_lines)
#   else {
#     motif_stops <- c(headers[-1] - 1, length(raw_lines))
#   }
#   parse_motifs <- function(x, y) {
#     motif <- raw_lines[x:y]
#     motif <- vapply(motif, function(x) as.numeric(strsplit(x,
#                                                            "\\s+")[[1]]), numeric(4))
#     matrix(motif, ncol = 4, byrow = TRUE)
#   }
#   parse_meta <- function(x) {
#     x <- strsplit(x, "\\s+")[[1]]
#     if (grepl("/", x[2])) {
#       y <- strsplit(x[2], "/")[[1]]
#       y <- strsplit(y[1], "\\(")[[1]]
#       x[2] <- y[1]
#       family <- strsplit(y[2], "\\)")[[1]][1]
#     }
#     else family <- character(0)
#     x2 <- strsplit(x[6], ",")[[1]]
#     nsites <- strsplit(strsplit(x2[1], "T:")[[1]][2], "\\(")[[1]][1]
#     bkgsites <- strsplit(strsplit(x2[2], "B:")[[1]][2], "\\(")[[1]][1]
#     pval <- strsplit(x2[3], "P:")[[1]][2]
#     c(name = x[2], nsites = nsites, bkgsites = bkgsites,
#       pval = pval, threshold = x[3], family = family)
#   }
#   motif_list <- mapply(parse_motifs, motif_starts, motif_stops,
#                        SIMPLIFY = FALSE)
#   motif_meta <- lapply(raw_lines[headers], parse_meta)
#   homer2umot <- function(x, y) {
#     mot <- universalmotif_cpp(name = x[1], nsites = ifelse(is.na(as.numeric(x[2])),
#                                                            numeric(0), as.numeric(x[2])), bkgsites = ifelse(is.na(as.numeric(x[3])),
#                                                                                                             numeric(0), as.numeric(x[3])), motif = t(y), alphabet = "DNA",
#                               type = "PPM", family = x[6])
#     validObject_universalmotif(mot)
#     mot
#   }
#   motifs <- mapply(homer2umot, motif_meta, motif_list, SIMPLIFY = FALSE)
#
#   ## The p-value calls a C++ code that can sometimes cause segmentation errors
#   ## The p-value is not needed all the time so I removed it
#   #pvals <- motif_pvalue(motifs, as.numeric(vapply(motif_meta,
#   #                                                function(x) x["threshold"], character(1))))
#
#   #motifs <- mapply(function(x, y) {
#   #  x@pval = y
#   #  x
#   #}, motifs, pvals)
#   if (length(motifs) == 1)
#     motifs <- motifs[[1]]
#   motifs
# }
