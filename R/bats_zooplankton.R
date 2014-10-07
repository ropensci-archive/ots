#' Get zooplankton data from BATS.
#' 
#' @export
#' @importFrom RCurl getURL
#' @examples \donttest{
#' (res <- bats_zooplankton())
#' res$meta
#' res$vars
#' }

bats_zooplankton <- function(){
  url <- paste0(bats_base(), 'zooplankton/bats_zooplankton.txt')
  res <- getURL(url, userpwd = "bats:guest")
  out <- process_zoo(res)
  structure(out, class="zooplankton")
}

#' @export 
print.zooplankton <- function(x, ..., n = 10){
  cat(sprintf("BATS: zooplankton data"), sep = "\n")
  cat("Metadata: output$meta", sep = "\n")
  cat("Variables: output$vars\n", sep = "\n")
  trunc_mat(x$data, n = n)
}

process_zoo <- function(x){
  xsplit <- strsplit(x, "\n")[[1]]
  ln_bats <- grep('/BATS', xsplit)
  ln_vars <- grep('/Variable list', xsplit)
  ln_data <- grep('/data', xsplit)
  meta <- structure(paste(xsplit[ ln_bats:(ln_vars-1) ], collapse = "\n"), class="meta")
  data <- read.table(text = paste(xsplit[ (ln_data+1):length(xsplit) ], collapse = "\n"), 
                     header = FALSE)
  names(data) <- shortvar
  vars <- data.frame(shortvar=shortvar, 
                     var=gsub("[0-9]+)\\s", "", xsplit[ (ln_vars+1):(ln_data-1) ]),
                     stringsAsFactors = FALSE)
  list(meta=meta, vars=vars, data=data)
}

shortvar <- c(
  "cruise",
  "date",
  "tow",
  "lat_deg",
  "lat_min",
  "lon_deg",
  "lon_min",
  "time_in",
  "time_out",
  "duration_min",
  "depth_max",
  "water_vol",
  "sieve_size",
  "weight_wet",
  "weight_dry",
  "weight_wet_vol",
  "dry_wet_vol",
  "tot_weight_wet_vol",
  "tot_weight_dry_vol",
  "weight_wet_vol_200",
  "weight_dry_vol_200",
  "tot_weight_wet_vol_200",
  "tot_weight_dry_vol_200"
)
