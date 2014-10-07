bats
=======

`bats` is an R client to retrieve data from the [Bermuda Atlantic Time-Series Study (BATS)]() ftp server.

## Quick start

### Install

```r
# install.packages("devtools")
devtools::install_github("sckott/bats")
library("bats")
```

### Zooplankton dataset

```r
bats_zooplankton()
```

```r
BATS: zooplankton data
Metadata: output$meta
Variables: output$vars

   cruise     date tow lat_deg lat_min lon_deg lon_min time_in time_out duration_min depth_max water_vol sieve_size
1   20066 19940406   1      31   33.89      63   52.45    1558     1626           28        -9   135.501        200
2   20066 19940406   1      31   33.89      63   52.45    1558     1626           28        -9   135.501        500
3   20066 19940406   1      31   33.89      63   52.45    1558     1626           28        -9   135.501       1000
4   20066 19940406   1      31   33.89      63   52.45    1558     1626           28        -9   135.501       2000
5   20066 19940406   1      31   33.89      63   52.45    1558     1626           28        -9   135.501       5000
6   20066 19940406   2      31   33.45      63   52.19    1625     1651           26        -9   227.565        200
7   20066 19940406   2      31   33.45      63   52.19    1625     1651           26        -9   227.565        500
8   20066 19940406   2      31   33.45      63   52.19    1625     1651           26        -9   227.565       1000
9   20066 19940406   2      31   33.45      63   52.19    1625     1651           26        -9   227.565       2000
10  20066 19940406   2      31   33.45      63   52.19    1625     1651           26        -9   227.565       5000
..    ...      ... ...     ...     ...     ...     ...     ...      ...          ...       ...       ...        ...
Variables not shown: weight_wet (dbl), weight_dry (dbl), weight_wet_vol (dbl), dry_wet_vol (dbl), tot_weight_wet_vol
     (dbl), tot_weight_dry_vol (dbl), weight_wet_vol_200 (dbl), weight_dry_vol_200 (dbl), tot_weight_wet_vol_200 (dbl),
     tot_weight_dry_vol_200 (dbl)
```

### More coming...
