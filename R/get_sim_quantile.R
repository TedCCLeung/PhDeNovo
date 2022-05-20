#' Function to
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @param x quantile from 0 to 1
#' @param normalized Whether normalized similarity should be used
#'
#' @return Numeric.
#' @export

get_sim_quantile <- function(
  x = 0.99,
  normalized = TRUE
){

  if (normalized){return(TFBS_similarity[, "PCC_normalized"] %>% as.numeric() %>% stats::quantile(x))
  } else {return(TFBS_similarity[, "PCC"] %>% as.numeric() %>% stats::quantile(x))
  }
}
