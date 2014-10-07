bats_base <- function() 'ftp://batsftp.bios.edu/BATS/'

#' @export 
print.meta <- function(x, ...){
  cat(x, sep = "\n")
}

#' @export 
print.citation <- function(x, ...){
  cat(x[[1]], sep = "\n")
}
