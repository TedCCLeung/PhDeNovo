#' Function to
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @param x
#' @param distance_measure PCC or KL
#' @param normalized Whether normalized similarity should be used
#'
#' @return Numeric.
#' @export

get_sim_quantile <- function(
  x = 0.99,
  distance_measure = "PCC",
  normalized = TRUE
){

  if (distance_measure == "PCC"){
    if (normalized){return(TFBS_similarity[, "PCC_normalized"] %>% as.numeric() %>% stats::quantile(x))
    } else {return(TFBS_similarity[, "PCC"] %>% as.numeric() %>% stats::quantile(x))
    }
  }

  if (distance_measure == "KL"){
    if (normalized){return(TFBS_similarity[, "KL_normalized"] %>% as.numeric() %>% stats::quantile(x))
    } else {return(TFBS_similarity[, "KL"] %>% as.numeric() %>% stats::quantile(x))
    }
  }

}
