#' Get California Cooperative Oceanic Fisheries Investigations (CALCOFI) data.
#'
#' FIXME: need to support other data sets in CALCOFI
#'
#' @importFrom data.table fread
#' @export
#' @param dataset A dataset code name, one of hydro, macrozoo, or X
#' @param path A path to store the files, Default: \code{~/.ots/kelp}
#' @param overwrite (logical) To overwrite the path to store files in or not, Default: TRUE.
#'
#' @examples \dontrun{
#' # hydro cast data
#' (res <- calcofi('hydro_cast'))
#'
#' # hydro bottle data
#' (res <- calcofi('hydro_bottle'))
#'
#' library('dplyr')
#' res$data %>%
#'  tbl_df %>%
#'  select(-cruz_sta) %>%
#'  group_by(year) %>%
#'  summarise(avg_wind_spd = mean(wind_spd, na.rm = TRUE)) %>%
#'  arrange(desc(avg_wind_spd)) %>%
#'  head
#' }

calcofi <- function(dataset='hydro_cast', path = "~/.ots/calcofi", overwrite = TRUE){
  dataset <- match.arg(dataset, c('hydro_bottle','hydro_cast','net'))
  zpath <- switch(dataset, hydro_bottle = "hydro", hydro_cast = "bottle", net = "net")
  if( !is_calcofi( path.expand(file.path(path, zpath)) ) ){
    res <- calcofi_GET(path, zpath, hydro_url, overwrite)
  }
  out <- process_calcofi(x=dataset, base=path, zpath=zpath)
  structure(out, class="calcofi")
}

#' @export
print.calcofi <- function(x, ..., n = 10){
  cat(sprintf("<CALCOFI data>"), sep = "\n")
  cat("Metadata: none yet", sep = "\n")
  trunc_mat(x$data, n = n)
}

calcofi_GET <- function(bp, wh="hydro", url, overwrite){
  dir.create(bp, showWarnings = FALSE, recursive = TRUE)
  fp <- file.path(bp, paste0(wh, ".zip"))
  res <- GET(url, write_disk(fp, overwrite))
  stop_for_status(res)
  untar(fp, exdir = path.expand(file.path(bp, wh)))
}

process_calcofi <- function(x, base, zpath){
  files <- list.files(file.path(base, zpath), full.names = TRUE, pattern = ".csv")
  tomatch <- switch(x, hydro_bottle = "bottle", hydro_cast = "cast", net = "net")
  get <- files[ grep(tomatch, files, ignore.case = TRUE) ]
  list(citation=calcofi_citation(), data=fread_csv(get))
}

calcofi_citation <- function(){
  structure('coming soon...', class="citations")
}

is_calcofi <- function(x){
  if(identical(list.files(x), character(0))){ FALSE } else {
    if( all(grepl('\\.csv', list.files(x))) ) TRUE else FALSE
  }
}

# Hydrographic Data - 1949 to Latest Update - tabulated bottle data from specific depths
hydro_url <- 'http://calcofi.org/downloads/database/CalCOFI_Database_csv.zip'

# Net Sampling - Bongo Net Displacement Volumes
macrozoo_url <- 'http://calcofi.org/downloads/database/195101-201307_Zoop.zip'
