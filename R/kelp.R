#' Get Kelp forest community data.
#' 
#' @import httr
#' @export
#' @param which A dataset code name, see \code{\link{kelp_datasets}}
#' @param path A path to store the files, Default: \code{~/.ots/kelp}
#' @param overwrite (logical) To overwrite the path to store files in or not, Default: TRUE.
#' @details After one download o the dataset, you won't have to download the data again.
#' @examples \donttest{
#' # list of datasets
#' kelp_datasets()
#' 
#' # get data
#' (res <- kelp("benthic_cover"))
#' head(res$headers)
#' head(res$vars)
#' res$citation
#' 
#' (res <- kelp("benthic_density"))
#' (res <- kelp("fish_density"))
#' (res <- kelp("fish_size"))
#' (res <- kelp("invert_size"))
#' head(res$headers)
#' (res <- kelp("subtidal"))
#' (res <- kelp("rdfc"))
#' (res <- kelp("kelp_size"))
#' (res <- kelp("kelp_supp_dens"))
#' (res <- kelp("art_recruit"))
#' }

kelp <- function(which='benthic_cover', path = "~/.ots/kelp", overwrite = TRUE)
{
  if(!is_kelp_data(path.expand(file.path(path, "data"))) || 
       !is_kelp_meta(path.expand(file.path(path, "metadata")))){
    kelp_GET(path, "data/", dataurl, overwrite) # get data
    kelp_GET(path, "metadata/", metadataurl, overwrite) # get metadata
  }
  
  out <- process_kelp(x=which, base=path)
  structure(out, class="kelp")
}

dataurl <- 'http://esapubs.org/archive/ecol/E094/245/KushnerEtAl2013-KFM-Data.zip'
metadataurl <- 'http://esapubs.org/archive/ecol/E094/245/KushnerEtAl2013-KFM-Metadata.zip'

kelp_GET <- function(bp, wh="data/", url, overwrite){
  dir.create(bp, showWarnings = FALSE, recursive = TRUE)
  fp <- file.path(bp, "kelp.zip")
  res <- GET(url, write_disk(fp, overwrite))
  stop_for_status(res)
  untar(fp, exdir = path.expand(file.path(bp, wh)))
}

is_kelp_data <- function(x){
  if(identical(list.files(x), character(0))){ FALSE } else {
    if(all(list.files(x) %in% unlist(unname(kelp_files)))) TRUE else FALSE
  }
}

is_kelp_meta <- function(x){
  if(identical(list.files(x), character(0))){ FALSE } else {
    if(all(list.files(x) %in% allmetafiles)) TRUE else FALSE
  }
}

#' @export 
print.kelp <- function(x, ..., n = 10){
  cat(sprintf("<Kelp data>"), sep = "\n")
  cat("Dataset headers: output$headers", sep = "\n")
  cat("Dataset variables: output$vars\n", sep = "\n")
  trunc_mat(x$data, n = n)
}

process_kelp <- function(x, base){
  dget <- file.path(base, "data", kelp_files[ names(kelp_files) %in% x ][[1]])
  hget <- file.path(base, "metadata", kelp_hfiles[ names(kelp_hfiles) %in% x ][[1]])
  vget <- file.path(base, "metadata", kelp_vfiles[ names(kelp_vfiles) %in% x ][[1]])
  list(citation=kelp_citation(), vars=read_csv(vget), headers=read_csv(hget), data=read_csv(dget))
}

read_csv <- function(x) read.csv(x, header = TRUE, sep = ",", stringsAsFactors=FALSE)

kelp_citation <- function(){
  structure('David J. Kushner, Andrew Rassweiler, John P. McLaughlin, and Kevin D. Lafferty. 2013.
A multi-decade time series of kelp forest community structure at the California Channel
Islands. Ecology 94:2655. http://dx.doi.org/10.1890/13-0562.1', class="citation")
}

kelp_files <- structure(list(
  "Artifical recruitment module data.csv",
  "Benthic Cover Data.csv",
  "Benthic Density Data.csv",
  "DiverList_1982-2011.csv",
  "Fish Density Data.csv",
  "Fish size frequency data.csv",
  "Giant kelp size frequency.csv",
  "Giant kelp supplementary density data.csv",
  "Invertebrate Size Frequency.csv",
  "RDFC data.csv",
  "Subtidal temperature data.csv"), 
  names = c('art_recruit','benthic_cover','benthic_density','diverlist','fish_density','fish_size',
            'kelp_size','kelp_supp_dens','invert_size','rdfc','subtidal')
)

kelp_hfiles <- structure(list(
  'Table10A_RDFC_headers.csv',
  'Table12A_fish_size_frequency_headers.csv',
  'Table13A_invertebrate_size_frequency_headers.csv',
  'Table14A_giant_kelp_size_frequency_headers.csv',
  'Table15A_giant_kelp_supplementary_density_headers.csv',
  'Table16A_artificial_recruitment_module_headers.csv',
  'Table17A_subtidal_temperature_headers.csv',
  'Table4A_benthic_density_headers.csv',
  'Table7A_benthic_cover_headers.csv',
  'Table9A_fish_density_headers.csv'), 
  names = c('rdfc','fish_size','invert_size','kelp_size','kelp_supp_dens','art_recruit',
            'subtidal','benthic_density','benthic_cover','fish_density')
)

kelp_vfiles <- structure(list(
  'Table10B_RDFC_variables.csv',
  'Table12B_fish_size_frequency_variables.csv',
  'Table13B_invertebrate_size_frequency_variables.csv',
  'Table14B_giant_kelp_size_frequency_variables.csv',
  'Table15B_giant_kelp_supplementary_density_variables.csv',
  'Table16B_artificial_recruitment_module_variables .csv',
  'Table17B_subtidal_temperature_variables.csv',
  'Table4B_benthic_density_variables.csv',
  'Table7B_benthic_cover_variables.csv',
  'Table9B_fish_density_variables.csv'), 
  names = c('rdfc','fish_size','invert_size','kelp_size','kelp_supp_dens','art_recruit',
            'subtidal','benthic_density','benthic_cover','fish_density')
)

kelp_others <- structure(list(
  'Table1_Monitoring_sites.csv',
  'Table18A_data_updates.csv',
  'Table18B_metadata_updates.csv',
  'Table2_History_of_fishing_restrictions.csv',
  'Table3_Species_monitored.csv'), 
  names = c('sites','data_updates','metadata_updates','history','species')
)

allmetafiles <- c(
  'Table1_Monitoring_sites.csv',
  'Table10A_RDFC_headers.csv',
  'Table10B_RDFC_variables.csv',
  'Table12A_fish_size_frequency_headers.csv',
  'Table12B_fish_size_frequency_variables.csv',
  'Table13A_invertebrate_size_frequency_headers.csv',
  'Table13B_invertebrate_size_frequency_variables.csv',
  'Table14A_giant_kelp_size_frequency_headers.csv',
  'Table14B_giant_kelp_size_frequency_variables.csv',
  'Table15A_giant_kelp_supplementary_density_headers.csv',
  'Table15B_giant_kelp_supplementary_density_variables.csv',
  'Table16A_artificial_recruitment_module_headers.csv',
  'Table16B_artificial_recruitment_module_variables .csv',
  'Table17A_subtidal_temperature_headers.csv',
  'Table17B_subtidal_temperature_variables.csv',
  'Table18A_data_updates.csv',
  'Table18B_metadata_updates.csv',
  'Table2_History_of_fishing_restrictions.csv',
  'Table3_Species_monitored.csv',
  'Table4A_benthic_density_headers.csv',
  'Table4B_benthic_density_variables.csv',
  'Table7A_benthic_cover_headers.csv',
  'Table7B_benthic_cover_variables.csv',
  'Table9A_fish_density_headers.csv',
  'Table9B_fish_density_variables.csv')

#' @export
#' @rdname kelp
kelp_datasets <- function(){
  data.frame(code=names(kelp_files), file=unname(unlist(kelp_files)), stringsAsFactors = FALSE)
}
