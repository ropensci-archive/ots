ots
=======

`ots` is an R client to retrieve data from various ocean time series datasets, including:

* BATS
* HOT
* CALCOFI
* LTER Kelp
* more to come...

Jump over to the issues page to suggest data sets to include or comment on ongoing data source integration progress.

## Quick start

### Install

```r
# install.packages("devtools")
devtools::install_github("ropensci/ots")
library("ots")
```

### BATS - Zooplankton dataset

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

### BATS - Production dataset

```r
bats_production()
```

```r
BATS: primary/bacterial production data
Metadata: output$meta
Variables: output$vars

          id   yymmdd     decy    lat   long dep1 dep2  salt  lt1   lt2   lt3  dark   t0    pp  thy1  thy2  thy3   thy
1  100038101 19881218 1988.965 31.669 64.049    5    5 -9.99 7.21  6.59 -9.90  0.75 1.26  6.15 -9.99 -9.99 -9.99 -9.99
2  100038102 19881218 1988.965 31.669 64.049   25   25 -9.99 6.00 -9.90 -9.90 -9.90 1.97 -9.99 -9.99 -9.99 -9.99 -9.99
3  100038103 19881218 1988.965 31.669 64.049   50   50 -9.99 3.62  2.69  3.19  1.02 1.57  2.15 -9.99 -9.99 -9.99 -9.99
4  100038104 19881218 1988.965 31.669 64.049   75   75 -9.99 2.21  1.40  1.55  1.43 1.47  0.29 -9.99 -9.99 -9.99 -9.99
5  100038105 19881218 1988.965 31.669 64.049  100  100 -9.99 1.15  1.78  8.48  0.95 1.46  2.85 -9.99 -9.99 -9.99 -9.99
6  100038106 19881218 1988.965 31.669 64.049  120  120 -9.99 1.29  0.75  1.47  1.01 2.08  0.16 -9.99 -9.99 -9.99 -9.99
7  100048101 19890127 1989.074 31.695 64.252   18   18 -9.99 3.77  3.75  4.36  0.18 0.19  3.78 -9.99 -9.99 -9.99 -9.99
8  100048102 19890127 1989.074 31.695 64.252   41   41 -9.99 3.66  3.55  3.92  0.21 0.21  3.50 -9.99 -9.99 -9.99 -9.99
9  100048103 19890127 1989.074 31.695 64.252   62   62 -9.99 2.17  2.33  2.05  0.16 0.09  2.02 -9.99 -9.99 -9.99 -9.99
10 100048104 19890127 1989.074 31.695 64.252   81   81 -9.99 0.93  0.92  1.02  0.19 0.09  0.77 -9.99 -9.99 -9.99 -9.99
..       ...      ...      ...    ...    ...  ...  ...   ...  ...   ...   ...   ...  ...   ...   ...   ...   ...   ...
```

### HOT dataset

```r
hot()
```

```r
HOT data
Metadata: output$meta
Variables: See Details section in ?hot

   cruise days      date   temp    sal phos  sil     DIC     TA   nDIC    nTA pHmeas_25C pHmeas_insitu pHcalc_25C pHcalc_insitu
1       1   30 31-Oct-88 26.283 35.186 0.08 0.71 1963.91 2319.5 1953.5 2307.2       -999          -999     8.1292        8.1097
2       2   62 02-Dec-88 25.659 34.984 0.09 0.99 1958.94 2304.9 1959.8 2306.0       -999          -999     8.1193        8.1092
3       3   99 08-Jan-89 24.610 35.028 0.07 0.93 1963.77 2305.0 1962.2 2303.2       -999          -999     8.1113        8.1168
4       4  148 26-Feb-89 23.479 34.883 0.09 0.88 1957.80 2295.5 1964.4 2303.2       -999          -999     8.1091        8.1316
5       5  177 27-Mar-89 24.278 34.735 0.12 2.01 1946.33 2283.0 1961.2 2300.4       -999          -999     8.1113        8.1218
6       6  229 18-May-89 23.870 35.019 0.09 1.42 1972.90 2306.7 1971.8 2305.4       -999          -999     8.0993        8.1158
7       7  266 24-Jun-89 25.755 34.600 0.14 0.92 1939.00 2275.0 1961.4 2301.3       -999          -999     8.1134        8.1018
8       8  301 29-Jul-89 25.358 34.949 0.10 1.49 1965.65 2301.8 1968.5 2305.2       -999          -999     8.1047        8.0991
9       9  327 24-Aug-89 26.202 34.675 0.11 1.75 1949.00 2285.4 1967.3 2306.8       -999          -999     8.1113        8.0930
10     10  356 22-Sep-89 26.330 34.775 0.07 0.90 1944.90 2287.1 1957.5 2301.9       -999          -999     8.1191        8.0990
..    ...  ...       ...    ...    ...  ...  ...     ...    ...    ...    ...        ...           ...        ...           ...
Variables not shown: pCO2calc_insitu (dbl), pCO2calc_20C (dbl), aragsatcalc_insitu (dbl), calcsatcalc_insitu (dbl),
     freeCO2_insitu (dbl), carbonate_insitu (dbl), notes (chr)
```

### LTER Kelp data

```r
kelp("benthic_cover")
```

```r
<Kelp data>
Dataset headers: output$headers
Dataset variables: output$vars

   Site Year Species       Date Replicates PointsPerReplicate CoverMean  CoverSE
1     1 1982    1001         NA         NA                 NA        NA       NA
2     1 1982    2001 2-May-1982         25                 20       3.6 1.021437
3     1 1982    2003         NA         NA                 NA        NA       NA
4     1 1982    2007 2-May-1982         25                 20       0.4 0.400000
5     1 1982    2008         NA         NA                 NA        NA       NA
6     1 1982    2014         NA         NA                 NA        NA       NA
7     1 1982    2017         NA         NA                 NA        NA       NA
8     1 1982    3001 2-May-1982         25                 20      52.6 4.682592
9     1 1982    3002 2-May-1982         25                 20       2.6 1.194432
10    1 1982    3003 2-May-1982         25                 20       7.2 2.256103
..  ...  ...     ...        ...        ...                ...       ...      ...
```

### CALCOFI data

```r
calcofi('hydro_cast')
```

```r
<CALCOFI data>
Metadata: none yet
   cst_cnt         cruise_id      cruz_sta dbsta_id                        cast_id      sta_id quarter sta_code distance
1        1 1949-03-01-C-31CR 9.629490e-311  5400560 19-4903CR-HY-060-0930-05400560 054.0 056.0       1      NST       NA
2        2 1949-03-01-C-31CR 9.629490e-311  5200750 19-4903CR-HY-060-2112-05200750 052.0 075.0       1      NST       NA
3        3 1949-03-01-C-31CR 9.629490e-311  5100850 19-4903CR-HY-061-0354-05100850 051.0 085.0       1      NST       NA
4        4 1949-03-01-C-31CR 9.629490e-311  5000950 19-4903CR-HY-061-1042-05000950 050.0 095.0       1      NST       NA
5        5 1949-03-01-C-31CR 9.629490e-311  5001040 19-4903CR-HY-061-1706-05001040 050.0 104.0       1      NST       NA
6        6 1949-03-01-C-31CR 9.629490e-311  4901140 19-4903CR-HY-062-0036-04901140 049.0 114.0       1      NST       NA
7        7 1949-03-01-C-31CR 9.629490e-311  5671460 19-4903CR-HY-063-0506-05671460 056.7 146.0       1      NST       NA
8        8 1949-03-01-C-31CR 9.629490e-311  5671360 19-4903CR-HY-063-1154-05671360 056.7 136.0       1      NST       NA
9        9 1949-03-01-C-31CR 9.629491e-311  5801270 19-4903CR-HY-063-1742-05801270 058.0 127.0       1      NST       NA
10      10 1949-03-01-C-31CR 9.629491e-311  5901170 19-4903CR-HY-063-2354-05901170 059.0 117.0       1      NST       NA
..     ...               ...           ...      ...                            ...         ...     ...      ...      ...
Variables not shown: date (chr), year (int), month (int), julian_date (int), julian_day (int), time (chr), lat_dec (dbl),
     lat_deg (int), lat_min (dbl), lat_hem (chr), lon_dec (dbl), lon_deg (int), lon_min (dbl), lon_hem (chr), rpt_line (dbl),
     st_line (dbl), ac_line (dbl), rpt_sta (dbl), st_station (dbl), ac_sta (dbl), bottom_d (int), secchi (int), forelu (int),
     ship_name (chr), ship_code (chr), data_type (chr), order_occ (int), event_num (int), cruz_leg (int), orig_sta_id (chr),
     data_or (chr), cruz_num (chr), intchl (dbl), intc14 (dbl), inc_str (chr), inc_end (chr), pst_lan (chr), civil_t (chr),
     timezone (int), wave_dir (int), wave_ht (int), wave_prd (int), wind_dir (int), wind_spd (int), barometer (dbl), dry_t
     (dbl), wet_t (dbl), wea (int), cloud_typ (int), cloud_amt (int), visibility (int)
```


### More coming...
