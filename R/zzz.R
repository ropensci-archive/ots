bats_base <- function() 'ftp://batsftp.bios.edu/BATS/'

#' @export
print.meta <- function(x, ...){
  cat(x, sep = "\n")
}

#' @export
print.citations <- function(x, ...){
  cat(x[[1]], sep = "\n")
}

read_csv <- function(x, header=TRUE){
  tmp <- read.csv(x, header = header, sep = ",", stringsAsFactors=FALSE)
  names(tmp) <- tolower(names(tmp))
  tmp
}

fread_csv <- function(x){
  tmp <- data.frame(suppressWarnings(fread(x)))
  names(tmp) <- tolower(names(tmp))
  tmp
}

cmp <- function(l) Filter(Negate(is.null), l)
