# BATS data helpers ---------
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

process_zoo <- function(x){
  xsplit <- strsplit(x, "\n")[[1]]
  ln_bats <- grep('/BATS', xsplit)
  ln_vars <- grep('/Variable list', xsplit)
  ln_data <- grep('/data', xsplit)
  meta <- structure(paste(xsplit[ ln_bats:(ln_vars - 1) ], collapse = "\n"), class = "meta")
  data <- read.table(text = paste(xsplit[ (ln_data + 1):length(xsplit) ], collapse = "\n"),
                     header = FALSE)
  names(data) <- shortvar
  vars <- data.frame(shortvar = shortvar,
                     var = gsub("[0-9]+)\\s", "", xsplit[ (ln_vars + 1):(ln_data - 1) ]),
                     stringsAsFactors = FALSE)
  list(meta = meta, vars = vars, data = data)
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


bats_route <- function(x) {
  switch(x,
         production = 'production/bats_production.dat',
         zooplankton = 'zooplankton/bats_zooplankton.txt',
         flux = "flux/bats_flux.dat"
  )
}

bats_parser <- function(x) {
  switch(x,
         production = process_prod,
         zooplankton = process_zoo,
         flux = process_prod
  )
}

bats_info <- function(x) {
  switch(x,
         production = "primary/bacterial production data",
         zooplankton = 'zooplankton data',
         flux = "flux data"
  )
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
