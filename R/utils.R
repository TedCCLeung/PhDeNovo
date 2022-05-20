addLeadingZeros <- function(
  num_vec
){
  digit_number <- floor(max(log10(num_vec)+1))
  return(stringr::str_pad(as.character(num_vec), digit_number, pad = "0"))
}
