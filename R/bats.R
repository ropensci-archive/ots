#' Get BATS (Bermuda Atlantic Time-series Study) data
#'
#' @export
#' @param dataset (character) One of production, zooplankton, or flux
#' @details Only these three data sets for now. Others may follow.
#' @references \url{http://bats.bios.edu/}
#' @examples \dontrun{
#' # Production
#' (res <- bats("production"))
#' res$meta
#' res$vars
#'
#' # Zooplankton
#' (res <- bats("zooplankton"))
#' res$meta
#' res$vars
#'
#' # Flux
#' (res <- bats("flux"))
#' res$meta
#' res$vars
#' }
bats <- function(dataset = "production"){
  dataset <- match.arg(dataset, c("production", "zooplankton", "flux"))
  url <- paste0(bats_base(), bats_route(dataset))
  url <- sub("ftp://", "ftp://bats:guest@", url)
  res <- curl::curl_download(url, tfile <- tempfile(fileext = ".txt"))
  out <- bats_parser(dataset)(paste0(readLines(res), collapse = "\n"))
  structure(out, class = "bats", info = bats_info(dataset))
}

#' @export
print.bats <- function(x, ..., n = 10){
  cat(paste0("BATS: ", attr(x, "info")), sep = "\n")
  cat("Metadata: output$meta", sep = "\n")
  cat("Variables: output$vars\n", sep = "\n")
  trunc_mat(x$data, n = n)
}
