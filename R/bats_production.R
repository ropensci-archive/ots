#' Get production data from BATS.
#'
#' @export
#'
#' @examples \donttest{
#' (res <- bats_production())
#' res$meta
#' res$vars
#' }

bats_production <- function(){
  url <- paste0(bats_base(), 'production/bats_production.dat')
  url <- sub("ftp://", "ftp://bats:guest@", url)
  res <- curl::curl_download(url, tfile <- tempfile(fileext = ".txt"))
  out <- process_prod(paste0(readLines(res), collapse = "\n"))
  structure(out, class = "production")
}

#' @export
print.production <- function(x, ..., n = 10){
  cat(sprintf("BATS: primary/bacterial production data"), sep = "\n")
  cat("Metadata: output$meta", sep = "\n")
  cat("Variables: output$vars\n", sep = "\n")
  trunc_mat(x$data, n = n)
}

process_prod <- function(x){
  xsplit <- strsplit(x, "\n")[[1]]
  ln_comments <- grep('/Comments', xsplit)
  ln_vars <- grep('/Variable list', xsplit)
  ln_quality <- grep('/Quality flags', xsplit)
  ln_data <- grep('/Variables', xsplit)
  comm <- paste(xsplit[ ln_comments:(ln_vars-1) ], collapse = "\n")
  qual <- paste(xsplit[ ln_quality:(ln_data-1) ], collapse = "\n")
  meta <- structure(paste0(comm, "\n", qual), class="meta")
  data <- read.table(text = paste(xsplit[ (ln_data+2):length(xsplit) ], collapse = "\n"),
                     header = FALSE)
  vars <- gsub("\\s+", "", strsplit(xsplit[ ln_data+1 ], ",")[[1]])
  names(data) <- tolower(vars[-length(vars)])
  vardf <- make_vardf(v=ln_vars, y=ln_quality, z=xsplit)
  list(meta=meta, vars=vardf, data=data)
}

make_vardf <- function(v, y, z){
  tmp <- z[ (v+1):(y-1) ]
  ln <- tmp[ 9:length(tmp) ]
  tmp <- do.call(rbind, lapply(ln, function(n){
      data.frame(
        t(gsub("^\\s+|\\s+$", "", strsplit(n, "\\s+=\\s+")[[1]])),
        stringsAsFactors = FALSE)
    })
  )
  names(tmp) <- c('variable','description')
  tmp$variable <- tolower(tmp$variable)
  tmp
}
