#' Get data from the Upper Ocean Proccesses Group (UOPG).
#'
#' @export
#' @param dataset A dataset code name, one of arabian_sea, asrex_91, asrex_93, biowatt, cmo,
#' coare, coop, fasinex, lotus, mlml89, mlml91, sesmoor, smile, or subduction. Or their
#' unique abbreviations.
#' @param type A data type, one of meteorology, water_velocity, temperature, or salinity. Or their
#' unique abbreviations.
#' @param path A path to store the files, Default: \code{~/.ots/uopg}
#' @param overwrite (logical) To overwrite the path to store files in or not, Default: TRUE.
#'
#' @details We download NetCDF files from UOPG, using \pkg{ncdf} to parse the data
#' to a data.frame.
#'
#' @references \url{http://uop.whoi.edu/archives/dataarchives.html}
#'
#' @examples \dontrun{
#' # Smile dataaets
#' (met <- uopg(dataset = 'smile', type = "meteorology"))
#' (sal <- uopg(dataset = 'smile', type = "salinity"))
#' (water <- uopg(dataset = 'smile', type = "water"))
#' (temp <- uopg(dataset = 'smile', type = "temp"))
#'
#' # biowatt dataaets
#' (biowatt_met <- uopg(dataset = 'biowatt', type = "meteorology"))
#' biowatt_met$data$`1`
#'
#' # lotus datasets
#' (lotus_met <- uopg(dataset = 'lotus', type = "meteorology"))
#' lotus_met$data$lotus
#' lotus_met$metadata
#'
#' # coare datasets
#' (coare_sal <- uopg(dataset = 'coare', type = "salinity"))
#' }

uopg <- function(dataset = 'smile', type = "meteorology", path = "~/.ots/uopg", overwrite = TRUE){
  dataset <- match.arg(dataset, uopg_datasets)
  type <- match.arg(type, c('meteorology','water_velocity','temperature','salinity'))
  zpath <- switch(type, meteorology = "met", water_velocity = "vel", temperature = "temp", salinity = "sal")
  files <- get_files(dataset, type)

  if ( !is_uopg( x = path.expand(file.path(path, dataset, zpath)), y = files ) ) {
    invisible(lapply(files, function(m) uopg_GET(path, dataset, zpath, files = m, overwrite = overwrite)))
    invisible(lapply(files, function(k) uopg_GET(path, dataset, zpath, files = k, ext = ".meta", overwrite)))
  }
  out <- process_uopg(dataset = dataset, path = path, zpath = zpath, files = files)
  structure(out, class = "uopg", dataset = dataset, type = type, path = path)
}

#' @export
print.uopg <- function(x, ..., n = 10){
  cat(sprintf("<UOPG data : %s> Total: [%s rows]; Datasets: [%s]", attr(x, "dataset"), sumnrow(x$data), length(x$data)), sep = "\n")
  cat("Metadata: output$meta", sep = "\n")
  cat(sprintf("First dataset [%s]:\n", names(x$data)[[1]]), sep = "\n")
  trunc_mat(x$data[[1]]$data, n = n)
}

#' @export
print.uopg_one <- function(x, ..., n = 10){
  cat(sprintf("<UOPG data> [%s rows]", NROW(x$data)), sep = "\n")
  cat("Metadata: output$meta", sep = "\n")
  trunc_mat(x$data, n = n)
}

#' @export
print.uopg_meta <- function(x, ...){
  cat(x)
  cat("\n")
}

sumnrow <- function(x) sum(sapply(x, NROW))
sumncol <- function(x) sum(sapply(x, NCOL))

uopg_GET <- function(bp, dataset, zpath, files, ext=".epic", overwrite){
  dirpath <- file.path(bp, dataset, zpath)
  dir.create(dirpath, showWarnings = FALSE, recursive = TRUE)
  fp <- file.path(dirpath, paste0(files, ext))
  res <- GET(file.path(uopg_base(), dataset, zpath, paste0(files, ext)), write_disk(fp, overwrite))
  stop_for_status(res)
}

process_uopg <- function(dataset, path, zpath, files){
  get <- file.path(path, dataset, zpath, paste0(files, ".epic"))
  metaget <- file.path(path, dataset, zpath, paste0(files, ".meta"))
  namez <- gsub(paste(dataset, zpath, sep = "|"), "", files)
  namez <- if (nchar(namez[[1]]) == 0) dataset else namez
  list(citation = uopg_citation(),
       data = get_uopg(x = get, y = namez),
       metadata = read_meta(x = metaget, y = namez))
}

uopg_citation <- function(){
  structure('coming soon...', class = "citations")
}

get_uopg <- function(x, y){
  tabs <- lapply(x, function(z) structure(list(data = ncdf2df(z)), class = "uopg_one"))
  setNames(tabs, y)
}

read_meta <- function(x, y){
  metas <- lapply(x, function(v) structure(paste0(readLines(v, warn = FALSE), collapse = "\n"),
                                           class = "uopg_meta"))
  setNames(metas, y)
}

is_uopg <- function(x, y){
  if (identical(list.files(x), character(0))) {
    FALSE
  } else {
    if ( all( sapply(paste0(y, '.epic'), function(z) grepl(z, list.files(x))) ) &&
        all( sapply(paste0(y, '.meta'), function(z) grepl(z, list.files(x))) )
    ) TRUE else FALSE
  }
}

get_files <- function(x, y){
  switch(paste0(x, "_", y),
         smile_meteorology = "smilemet",
         smile_water_velocity = c("smileC2vel","smileC3vel","smileC4vel","smileG3vel","smileM3vel"),
         smile_temperature = c("smileG3temp","smileC2temp","smileC3temp","smileC4temp","smileM3temp"),
         smile_salinity = "smileC3sal",
         biowatt_meteorology = c("biowatt1met","biowatt2met","biowatt3met"),
         biowatt_water_velocity = c("biowatt1vel","biowatt2vel","biowatt3vel"),
         biowatt_temperature = c("biowatt1temp","biowatt2temp","biowatt3temp"),
         lotus_meteorology = "lotusmet",
         lotus_water_velocity = c("lotusnsvel","lotus1deepvel","lotus2deepvel"),
         lotus_temperature = c("lotusnstemp","lotus1deeptemp","lotus2deeptemp"),
         coare_meteorology = "coaremet",
         coare_water_velocity = "coarevel",
         coare_temperature = "coaretemp",
         coare_salinity = "coaresal"
  )
}

uopg_base <- function() 'http://uop.whoi.edu/archives'

uopg_datasets <- c('arabian_sea', 'asrex_91', 'asrex_93', 'biowatt', 'cmo', 'coare',
                   'coop', 'fasinex', 'lotus', 'mlml89', 'mlml91', 'sesmoor',
                   'smile', 'subduction')
