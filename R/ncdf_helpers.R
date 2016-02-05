ncdf2df <- function(file){
  nc <- ncdf4::nc_open(file)
  on.exit(ncdf4::nc_close(nc))

  dims <- names(nc$dim)
  out <- list()
  for (i in seq_along(dims)) {
    out[[dims[i]]] <- ncdf4::ncvar_get(nc, nc$dim[[dims[i]]])
  }
  out$time <- sapply(out$time, convert_time)
  vars <- names(nc$var)
  outvars <- list()
  for (i in seq_along(vars)) {
    outvars[[ vars[i] ]] <- as.vector(ncdf4::ncvar_get(nc, vars[i]))
  }
  df <- do.call("cbind.data.frame", outvars)
  rows <- length(outvars[[1]])
  time <- rep(out$time, each = rows/length(out$time))
  lat <- rep(rep(out$lat, each = length(out$lon)), length(out$time))
  lon <- rep(rep(out$lon, times = length(out$lat)), times = length(out$time))
  meta <- data.frame(time, lat, lon, stringsAsFactors = FALSE)
  return(cbind(meta, df))
}

convert_time <- function(n = NULL, isoTime = NULL,
  units = "seconds since 1970-01-01T00:00:00Z", url = "http://coastwatch.pfeg.noaa.gov",
  method = "local", ...) {

  if (!is.null(n)) stopifnot(is.numeric(n))
  if (!is.null(isoTime)) stopifnot(is.character(isoTime))
  check1notboth(n, isoTime)
  if (method == "local") {
    format(as.POSIXct(cmp(list(n, isoTime))[[1]], origin = "1970-01-01T00:00:00Z", tz = "UTC"),
           format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  } else {
    args <- cmp(list(n = n, isoTime = isoTime, units = units))
    res <- GET(paste0(pu(url), '/erddap/convert/time.txt'), query = args, ...)
    stop_for_status(res)
    content(res, "text", encoding = "UTF-8")
  }
}

check1notboth <- function(x, y) {
  if (is.null(x) && is.null(y)) {
    stop(sprintf("One of %s or %s must be non-NULL",
                 deparse(substitute(x)), deparse(substitute(y))), call. = FALSE)
  }
  if (!is.null(x) && !is.null(y)) {
    stop(sprintf("Supply only one of %s or %s",
                 deparse(substitute(x)), deparse(substitute(y))), call. = FALSE)
  }
}

pu <- function(x) sub("/$|//$", "", x)
